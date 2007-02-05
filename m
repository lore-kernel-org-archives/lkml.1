Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXBEWWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXBEWWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXBEWWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:22:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXBEWWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:22:04 -0500
Date: Mon, 5 Feb 2007 14:21:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170712393.29759.925.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> 
 <1170711587.29759.909.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
 <1170712393.29759.925.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, David Woodhouse wrote:
>
> Ten years ago, people used 'depends on' to fix the tools, so that then
> you want to enable something like USB_STORAGE, it can automatically turn
> SCSI on for you.
> 
> Isn't that what you wanted?

Try it. It's not what it does. 

If you have a 

	depends on SCSI

and you did not say you wanted SCSI, you'll never even *see* the question.

It will *not* turn on SCSI automatically for you. Quite the reverse. It 
will not even show you the option.

In contrast, it you do a

	select SCSI

you'll see the question, and it will do exactly what you claim "depends 
on" does. Which yes, is what we want.

So what's your problem? You argue as if you didn't understand the 
difference between "depends on" and "select".

As an example of this, look at SATA. It does "select SCSI" if you select 
CONFIG_ATA, _exactly_ because it actually wants to turn on the SCSI layer 
*regardless* of what the user said. Because if the user said "n" to SCSI, 
the user simply didn't know that the SATA code uses the SCSI code.

Which is an example of what I've been saying all along: "select" makes 
sense. USB_STORAGE should have done the same.

Claiming that "select" is evil is just totally strange.

		Linus
