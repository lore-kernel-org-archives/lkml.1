Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYBDSH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYBDSH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYBDSHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:07:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54786 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYBDSHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:07:48 -0500
Date: Mon, 4 Feb 2008 19:07:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
Message-ID: <20080204180753.GB16050@uranus.ravnborg.org>
References: <87zlugsox9.fsf@saeurebad.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlugsox9.fsf@saeurebad.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 04:48:34PM +0100, Johannes Weiner wrote:
> Hi,
> 
> current approaches to have printk format strings in the corresponding
> data section to the function they appear in look like the following (at
> least what I have seen so far):
> 
> int __init some_function(void)
> {
> 	static char errmsg[] __initdata = "failure %s in %s\n";
> 
>         [...]
>         printk(errmsg);
>         [...]
> }
> 
> The attached patch allows something along the lines:
> 
> int __init some_function(void)
> {
>         [...]
>         pr_init(KERN_WARNING "failure %s in %s\n", ...);
>         [...]
> }
> 
> Another idea I had was to make printk a macro that figures out the
> section of the surrounding function and then moves the data
> automatically when it is a literal, but I couldn't find mechanisms that
> allow this.  Anyone of you got an idea?
> 
> What do you think in general?

What is the rationale behind this?
In other words why should we investigate time looking into the matter?

If you say "saving memory" then please let us know with specific examples
in what area these savings will really pay off.

Thanks,
	Sam
