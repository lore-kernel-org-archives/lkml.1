Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXJTE0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXJTE0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXJTE0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:26:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbXJTE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:26:22 -0400
Date: Fri, 19 Oct 2007 21:25:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>, Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
cc: rdunlap@xenotime.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git Kconfig regression
In-Reply-To: <20071020041140.0E41423A734@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <alpine.LFD.0.999.0710192121140.3794@woody.linux-foundation.org>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071019184607.06e1eef9.randy.dunlap@oracle.com>
 <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <47196165.8070406@oracle.com> <20071019195535.0dbafd39.rdunlap@xenotime.net>
 <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
 <20071020041140.0E41423A734@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, David Brownell wrote:

> > My (quick, meaning that I may have missed something) testing
> > indicates that the problem is in the patches attached.
> 
> Yes, reverting this seems to resolve the problem:
> 
> > a5bf3d891a6a0fb5aa122792d965e3774108b923
> >
> > Change kconfig behavior so that mixing bool and tristate config settings in
> > a choice is possible and has the desired effect of offering just the
> > tristate options individually if the choice gets set to M, and a normal
> > boolean selection if the choice gets set to Y.
> 
> Reverting this patch also fixes a second problem that I didn't
> mention:  various dependent options couldn't be enabled.
> 
> Again in drivers/usb/gadget/Kconfig, examples include the
> ability to configure the Ethernet gadget to act as an RNDIS
> peripheral; or enabling Mass Storage gadget debug options.
> 
> 
> Good sleuthing, and thanks!
> 
> Now we just need to see that patch reverted before RC1... I don't
> know how Linus deals with all his LKML mail, so I cc'd him in
> the hope that direct messages get through a bit faster.

Ok, I'll revert it, but wanted to make sure that the parties that pushed 
the change are aware of this.

		Linus 
