Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZBQLWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZBQLWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZBQLWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:22:05 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48351 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZBQLWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:22:03 -0500
Date: Tue, 17 Feb 2009 11:19:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Justin Madru <jdm64@gawab.com>
cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
In-Reply-To: <4999DD31.4010504@gawab.com>
Message-ID: <Pine.LNX.4.64.0902171102260.15234@blonde.anvils>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl>
 <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl>
 <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com>
 <499986D0.3000205@ru.mvista.com> <4999BD1A.1060101@gawab.com>
 <4999C195.5050905@ru.mvista.com> <4999DD31.4010504@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Justin Madru wrote:
> Sergei Shtylyov wrote:
> >
> > If 12609 is truly a post-2.6.28 regression and 12263 is post-2.6.27
> > regresssion, this just cannot be.
> 
> Maybe the reporter of #12609 didn't notice/test kernels 28-rc1 to 28. Or maybe
> the difference in hardware is
> the issue, but the bug is still the same. Don't know.

Sorry Justin, you must be confused: as Sergei says,
#12609 and #12263 can only be different.

I was one of the reporters of #12609, and I do know it's a post-2.6.28
regression (and Larry said so too), and one fix (not the preferred fix)
is to revert the ata_bmdma32_port_ops from 2.6.29-rc, and the preferred
fix is to improve the ata_sff_data_xfer32() introduced in 2.6.29-rc1.

2.6.28 does not contain any ata_bmdma32_port_ops, nor ata_sff_data_xfer32(),
not did 2.6.28-rc1 contain them.  So it is impossible for the reversion of
the patch that introduced them to fix any problem on 2.6.28.

I'm quite prepared to believe that your #12263 manifests similarly to
#12609, and that a tip tree which contains a fix for #12609 contains
a fix for #12263; but please, those bugs are not the same, and they
don't have the same fix.

Hugh
