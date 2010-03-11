Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0CKORe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:17:34 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43792 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0CKORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:17:33 -0500
Date: Thu, 11 Mar 2010 15:17:31 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on
 AMD
Message-ID: <20100311141731.GD18564@aftab>
References: <20100308170637.GA26565@aftab>
 <20100311132202.GF11837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311132202.GF11837@elte.hu>
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

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, Mar 11, 2010 at 02:22:02PM +0100

> > we're getting the following oopsie with current -git. Proposed patch is below:
> 
> alas, your patch doesnt always build:
> 
> drivers/built-in.o: In function `agp_amd64_probe':
> amd64-agp.c:(.devinit.text+0x81d2): undefined reference to `cache_k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8207): undefined reference to `k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8409): undefined reference to `num_k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8500): undefined reference to `k8_northbridges'

Ah, yep, this patch removes the dependency on K8_NB and it could be that
your config has CONFIG_K8_NB disabled but with CONFIG_AGP_AMD64 enabled.
Can you send me your .config pls?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
