Return-Path: <linux-kernel-owner+w=401wt.eu-S1764599AbYCDPjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764599AbYCDPjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbYCDPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:39:24 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:55078 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbYCDPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:39:20 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JX7PSQ-04-2PG-01
Date: Tue, 4 Mar 2008 08:39:57 -0700
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Geode LX800 hanging at boot in vesa_store_edid() w/
	CONFIG_FIRMWARE_EDID=y
Message-ID: <20080304153957.GF11357@cosmic.amd.com>
References: <76366b180803032311g40593189o47f727e4bba52c43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180803032311g40593189o47f727e4bba52c43@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 04 Mar 2008 15:31:44.0577 (UTC) FILETIME=[DA367B10:01C87E0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/08 02:11 -0500, Andrew Paprocki wrote:
> I have a LX800 board which hangs at boot time *only* if no monitor is
> plugged into the VGA port. It hangs for about 20 minutes and then
> continues booting.  If a monitor is plugged into the system while it
> is hung, it recovers after a few minutes and continues booting.  I
> added puts() debugging in the kernel main() and it is hanging in
> vesa_store_edid() in the first asm() call:
> 
>         /* Note: The VBE DDC spec is different from the main VESA spec;
>            we genuinely have to assume all registers are destroyed here. */
> 
>         asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
>             : "+a" (ax), "+b" (bx)
>             :  "c" (cx), "D" (di)
>             : "esi");
> 
> After waiting for a really long time, this int10 finishes and it
> executes the second asm() call which returns right away.  I never
> tried booting the system without a head, so I never noticed this
> problem before.  Does this point to some kind of BIOS bug?  The system
> boots fine when CONFIG_FIRMWARE_EDID is disabled (I'm not even sure if
> it should have been enabled in the first place), but I want to make
> sure the manufacturer is alerted if there is a BIOS problem.

This is most likely a BIOS bug.  Once we go in to the hated INT10,
we lose all control (and visiblity).  If I can make silly assumptions
based on your description, it looks like there may be some sort of very
long timeout on the bitbanging code in the BIOS that does the DDC.

Can you give me the details of the platform and BIOS vendor?  I'll work
the issue from my end.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

