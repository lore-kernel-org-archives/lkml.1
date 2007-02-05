Return-Path: <linux-kernel-owner+w=401wt.eu-S964928AbXBEWhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbXBEWhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXBEWhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:37:01 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11134 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbXBEWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:37:00 -0500
Date: Mon, 5 Feb 2007 14:31:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-Id: <20070205143110.fca62b57.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	<20070205084523.GA21858@elte.hu>
	<1170682488.29759.795.camel@pmac.infradead.org>
	<20070205155627.GA8354@elte.hu>
	<1170692539.29759.856.camel@pmac.infradead.org>
	<20070205162635.GA755@elte.hu>
	<20070205163152.GA2464@elte.hu>
	<Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	<1170710272.29759.894.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	<1170711587.29759.909.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
	<1170712393.29759.925.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 14:21:41 -0800 (PST) Linus Torvalds wrote:

> On Mon, 5 Feb 2007, David Woodhouse wrote:
> >
> > Ten years ago, people used 'depends on' to fix the tools, so that then
> > you want to enable something like USB_STORAGE, it can automatically turn
> > SCSI on for you.
> > 
> > Isn't that what you wanted?
> 
> Try it. It's not what it does. 
> 
> If you have a 
> 
> 	depends on SCSI
> 
> and you did not say you wanted SCSI, you'll never even *see* the question.
> 
> It will *not* turn on SCSI automatically for you. Quite the reverse. It 
> will not even show you the option.
> 
> In contrast, it you do a
> 
> 	select SCSI
> 
> you'll see the question, and it will do exactly what you claim "depends 
> on" does. Which yes, is what we want.
> 
> So what's your problem? You argue as if you didn't understand the 
> difference between "depends on" and "select".

I think the problem is "who is make *config" for?".

David wants it to be for developers (ISTM) and "select" is a
hassle for us.

Linus wants it to be for (unadvanced) users, but they tend to just
use distro kernels and distro configs, according to David, and I
agree with that.

So I think that make *config is more for developers and advanced
(not embedded) users.

> As an example of this, look at SATA. It does "select SCSI" if you select 
> CONFIG_ATA, _exactly_ because it actually wants to turn on the SCSI layer 
> *regardless* of what the user said. Because if the user said "n" to SCSI, 
> the user simply didn't know that the SATA code uses the SCSI code.
> 
> Which is an example of what I've been saying all along: "select" makes 
> sense. USB_STORAGE should have done the same.
> 
> Claiming that "select" is evil is just totally strange.

It's a real problem for developers who actually try to modify
configs.

---
~Randy
