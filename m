Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYBDUYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYBDUYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbYBDUYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:24:30 -0500
Received: from saeurebad.de ([85.214.36.134]:41189 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061AbYBDUY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:24:29 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
References: <87zlugsox9.fsf@saeurebad.de>
	<20080204180753.GB16050@uranus.ravnborg.org>
Date: Mon, 04 Feb 2008 21:23:29 +0100
In-Reply-To: <20080204180753.GB16050@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Mon, 4 Feb 2008 19:07:53 +0100")
Message-ID: <87ve54sc72.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Sam Ravnborg <sam@ravnborg.org> writes:

> On Mon, Feb 04, 2008 at 04:48:34PM +0100, Johannes Weiner wrote:
>> Hi,
>> 
>> current approaches to have printk format strings in the corresponding
>> data section to the function they appear in look like the following (at
>> least what I have seen so far):
>> 
>> int __init some_function(void)
>> {
>> 	static char errmsg[] __initdata = "failure %s in %s\n";
>> 
>>         [...]
>>         printk(errmsg);
>>         [...]
>> }
>> 
>> The attached patch allows something along the lines:
>> 
>> int __init some_function(void)
>> {
>>         [...]
>>         pr_init(KERN_WARNING "failure %s in %s\n", ...);
>>         [...]
>> }
>> 
>> Another idea I had was to make printk a macro that figures out the
>> section of the surrounding function and then moves the data
>> automatically when it is a literal, but I couldn't find mechanisms that
>> allow this.  Anyone of you got an idea?
>> 
>> What do you think in general?
>
> What is the rationale behind this?
> In other words why should we investigate time looking into the matter?
>
> If you say "saving memory" then please let us know with specific examples
> in what area these savings will really pay off.

I was not claiming anything.  The thing is that I have seen people using
code as schematized in the first code example.  And the point of this
patch is to make the placing of string literals in disposable sections -
which is already done - more convenient.

Using code as in the first example is just ugly.  My approach is to make
it less ugly.  But after all, it was not my idea to move the string
literals.

drivers/net/3c505.c does it, grep for notfound_msg for an in-tree
example.

You were asking me my own question.  I placed an `RFC' in the Subject:
because I am interested in your (and others) view on this topic.

I will convert some of the code to use the macros I introduced and look
if it gains some significant size improvements on a common desktop
configuration as I have it on my laptop.

	Hannes
