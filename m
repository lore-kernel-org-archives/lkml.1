Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZFMDsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZFMDsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 23:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZFMDsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 23:48:39 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:51554 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFMDsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 23:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=gDIWd68embzacnlmkxnyyWIQKVUqiIpEW/ENwOi6Qa07XBsEQSHzVOjw2wXrkaKAZy
         +asfY0bbxTu88OpTdOunRpcimmTghHp4gI9MWuSiOHsQ4T9e3fZRQy/eSJ9GFSKy9hvp
         nIq6NqvzppclmX5OU7la1Ff8oBmqFEMvPllzU=
MIME-Version: 1.0
In-Reply-To: <20090611191152.GD16787@mit.edu>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	 <20090405011355.GE7553@mit.edu>
	 <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	 <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
	 <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
	 <20090405062626.GA7760@mit.edu>
	 <9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com>
	 <9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
	 <20090611191152.GD16787@mit.edu>
Date: Fri, 12 Jun 2009 21:48:41 -0600
Message-ID: <9b1675090906122048o35698c09x13cc7cf7650ac9ae@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I didn't reply earlier.  I got busy with some server troubles and such.

On Thu, Jun 11, 2009 at 1:11 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Sat, Jun 06, 2009 at 09:14:43PM -0600, Trenton D. Adams wrote:
>> I'm back into doing some Java development, and it's happening again.
>> I'm running 2.6.30-rc7, and I did a SysReq+T, I hope this is helpful.
>> I've attached a txt.gz file, because it's 367K to my
>> /var/log/messages.
>>
>> The important stuff, I believe, is the Java related stuff.  As a quick
>> refresher to this problem, it appears to be related to how my Java IDE
>> saves the file, and perhaps something doesn't release the futex right
>> away?
>
> Have you checked your memory usage via SysReq-m, or /proc/meminfo or
> simply using "free".  I'm seeing a lot of processes in do_page_fault,
> which is interesting, especially in the non-Java processes.

I wasn't even aware of a SysReq-m.  I'll try that next time.  <rant>I
do wish the Macbook had a hard drive activity light *rolls
eyes*.</rant>

>
> Back in April, your vmstat output didn't show much swapping activity,
> but maybe there was more paging activity that didn't show up there?

Not sure I understand.  Paging without swapping?  I thought they were
one in the same, please explain; it's been a long time since I studied
kernel related theory.

>
>> I've also seen these symptoms previously...
>>
>> 1. Problem arises, I Ctrl-C the process when I notice the system
>> getting really sluggish.
>> 2. Start process again, and it locks up the machine for about an hour
>
> What sort of process where you typicalling trying to kill using ^C?

It's maven, which spawns javac (java compiler), as well as does
various other tasks such as making connections to the Internet, local
directories, etc.
