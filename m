Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610Ab0AUSgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0AUSgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 13:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194Ab0AUSgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 13:36:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49000 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0AUSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 13:36:44 -0500
Date: Thu, 21 Jan 2010 19:36:53 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86, smp: Adjust native_wbinvd for
 smp_call_function-helpers
Message-ID: <20100121183653.GA14808@aftab>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
 <1264092093-13739-3-git-send-email-bp@amd64.org>
 <4B5897F7.5000008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5897F7.5000008@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 10:07:51AM -0800, H. Peter Anvin wrote:
> On 01/21/2010 08:41 AM, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add a wbinvd_on_cpu() helper and fold the void * arg in the wbinvd macro
> > definition so that native_wbinvd can be used in the smp_call_function_*
> > helpers as a pointed-to function.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> This patch is a lot of extra uglification just to avoid a simple jump
> stub -- and even then only with PV enabled -- for an operation which is
> then going to perform an IPI and WBINVD.  That doesn't exactly seem like
> the right tradeoff.
> 
> As such, I'm going to request that you just put a simple stub function
> in lib/smp.c rather than this whole patchset (well, the smp.h bit
> obviously needs to stay.)

..and I was wrapping the wrong way: wbinvd() was going to hide the void
* function argument while a simple stub in lib/smp.c could wrap around
wbinvd() which is much more cleaner. Thanks.

Will redo the patchset tomorrow.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
