Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0BPP0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:26:46 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21720 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0BPP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:26:45 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN1b0bMzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXXXK6-02-93K-02
X-M-MSG: 
Date: Tue, 16 Feb 2010 16:26:31 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cacheinfo: Remove NUMA dependency, fix for
 D1 Isntanbul
Message-ID: <20100216152631.GA754@aftab>
References: <1266234236-24749-1-git-send-email-bp@amd64.org>
 <tip-472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7@git.kernel.org>
 <20100216140246.GA31213@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100216140246.GA31213@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Feb 2010 15:26:32.0065 (UTC) FILETIME=[6AE26F10:01CAAF1C]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 03:02:46PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > Commit-ID:  472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
> > Gitweb:     http://git.kernel.org/tip/472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
> > Author:     Borislav Petkov <borislav.petkov@amd.com>
> > AuthorDate: Mon, 15 Feb 2010 12:43:56 +0100
> > Committer:  H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Mon, 15 Feb 2010 12:32:48 -0800
> > 
> > x86, cacheinfo: Remove NUMA dependency, fix for D1 Isntanbul
> 
> FYI, this commit broke the build in -tip testing:
> 
>  arch/x86/built-in.o: In function `store_cache_disable':
>  intel_cacheinfo.c:(.text+0xc509): undefined reference to `amd_get_nb_id'
>  arch/x86/built-in.o: In function `show_cache_disable':
>  intel_cacheinfo.c:(.text+0xc7d3): undefined reference to `amd_get_nb_id'

Argh,

In the attached .config we have

# CONFIG_CPU_SUP_AMD is not set

but <arch/x86/kernel/cpu/amd.c> is built only when CONFIG_CPU_SUP_AMD is
enabled. Possible fixes are:

a) push amd_get_nb_id() into <asm/processor.h>.

b) make L3 cache index disable code dependent on CONFIG_CPU_SUP_AMD

IMO, a) is a short-term fix while b) is the better thing to do. I might
be able to get something done in time for the merge window. Let me know
which way you want to go.

Thanks.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center

