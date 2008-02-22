Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYBVSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYBVSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYBVSlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:41:03 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54289 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYBVSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:40:59 -0500
Date: Fri, 22 Feb 2008 11:02:30 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be
 clustered_box
In-reply-to: <p73hcg189g1.fsf@bingen.suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802221102.31019.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <p73hcg189g1.fsf@bingen.suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 04:25:18 am Andi Kleen wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> 
> > quad core 8 socket system will have apic id lifting.the apic id range could
> > be [4, 0x23]. or [8, 0x27]. apic_is_clustered_box will think that need to three clusters
> > and that is large than 2. So it is treated as clustered_box.
> >
> > and will get
> >
> > Marking TSC unstable due to TSCs unsynchronized
> >
> > even the CPUs have X86_FEATURE_CONSTANT_TSC set.
> >
> > this patch offset back the apic before get apic clusterid.
> >
> > or use dmi to get apic_is_clustered?
> 
> The clustered check is for Summit and es7000 systems
> On 64bit systems it might be actually possible to trigger
> this based on SLIT instead. But you'll need to check with
> the IBM Summit/Unisys es7000 developers if that works or not
> 
> If you don't want to do that the safer way would be probably
> the check if there are holes between the CPUs APIC numbers.
> If yes then it's likely clustered mode. I think that would
> be better than to disable it unconditionally for apic lifting
> like your patches does.

so for that box [4, 0x23] still could be apic clustered? there is a hole [0,3]..

is their box using AMD cpu or not?

YH

