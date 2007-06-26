Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXFZKTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXFZKTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFZKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:19:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:41253 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751655AbXFZKTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:19:33 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+Uw0Jh7seUC8oo/+VI9d9NDxoytoI1l0Abe+Nx6s
	2QtTJxfS0rNtmo
Date: Tue, 26 Jun 2007 12:20:26 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Amitabha Roy <amitabha.roy@gmail.com>
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: DIE_NMI_IPI to oprofile ?
Message-ID: <20070626102026.GA19408@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Amitabha Roy <amitabha.roy@gmail.com>,
	oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <cf9d85500706252351k68924882s2c6bc58454d1bb9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf9d85500706252351k68924882s2c6bc58454d1bb9b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 23:51:51 -0700, Amitabha Roy wrote:
> Hi
> 
> >From looking at the default_do_nmi code in traps.c it seems that (at
> least for the non BSP case, with reason=0) the die notifier chain gets
> called with val=DIE_NMI_IPI.
> 
> However in the profile_exceptions_notify_handler we check for DIE_NMI
> (and not DIE_NMI_IPI) to decide if we want to cycle through the
> counters. This seems wrong to me unless I am missing something (which
> must be the case, otherwise this code is broken :).
> 
> Can anyone help me understand this ?

notify_die(DIE_NMI, ...) is also called from nmi_watchdog_tick. So
depending on "reason" you call:

notify_die(DIE_NMI_IPI, ...)
nmi_watchdog_tick(...)
---> notify_die(DIE_NMI, ...)

or just

notify_die(DIE_NMI, ...)

HTH
Björn
