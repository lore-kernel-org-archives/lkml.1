Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbXETPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbXETPjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXETPjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:39:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbXETPjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:39:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
Date: Sun, 20 May 2007 17:37:39 +0200
User-Agent: KMail/1.9.6
Cc: dan@dennedy.org, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de>
In-Reply-To: <46506912.9020904@s5r6.in-berlin.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705201737.40631.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19jcTuYVy2G84Rvp8CAQ6W76Rx4zqS1xiLGqrz
 buIeeNUVLbC/GybgAsxTELDOh9KXb1XMEY5K/80et/3C/hmweM
 So4pim7z2CCS5MtNVfwow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007, Stefan Richter wrote:
> maybe we should change
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
>         /* contents of Isochronous Cycle Timer register,
>            as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
>         __u32 cycle_timer;
> 
>         /* local time in microseconds since Epoch,
>            simultaneously read with cycle timer */
>         __u64 local_time;
> };
> 
> to
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
>         /*
>          * least significant 32 bits are contents of Isochronous Cycle
>          * Timer register, as in OHCI 1.1 clause 5.13 (also with
>          * non-OHCI hosts)
>          */
>         __u64 cycle_timer;
> 
>         /*
>          * local time in microseconds since Epoch,
>          * simultaneously read with cycle timer
>          */
>         __u64 local_time;
> };
> 
> before a libraw1394 with get-cycle-timer support is released.

Yes, if you still have the chance to change this without breaking
users, that would be ideal.

I assume that struct raw1394_iso_packets is already set in stone,
right? Otherwise it would be good to make that a compatible structure
as well.

	Arnd <><
