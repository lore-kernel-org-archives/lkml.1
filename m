Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092Ab0AUQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0AUQbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925Ab0AUQbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:31:49 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41975 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0AUQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:31:49 -0500
Date: Thu, 21 Jan 2010 17:31:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, cacheinfo: Calculate L3 indexes
Message-ID: <20100121163158.GC10321@aftab>
References: <1263899279-30739-1-git-send-email-bp@amd64.org>
 <1263899279-30739-4-git-send-email-bp@amd64.org>
 <4B578E93.9040709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B578E93.9040709@zytor.com>
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

On Wed, Jan 20, 2010 at 03:15:31PM -0800, H. Peter Anvin wrote:
> On 01/19/2010 03:07 AM, Borislav Petkov wrote:
> > We need to know the valid L3 indexes interval when disabling them over
> > /sysfs. Do that when the core is brought online and add boundary checks
> > to the sysfs .store attribute.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > @@ -161,6 +162,7 @@ struct _cpuid4_info_regs {
> >  	union _cpuid4_leaf_ecx ecx;
> >  	unsigned long size;
> >  	unsigned long can_disable;
> > +	unsigned int l3_indexes;
> >  };
> >  
> 
> Hmmm... 32, 64, 64, 32 bits... we could move up the l3_indexes variable
> here.   However, more likely is that "size" and "can_disable" have no
> business being unsigned long in the first place -- especially the latter
> seems to be actually used as a boolean, and really should be "bool".

good point.

> Second, the preferred plural of "index" is "indices" (although both are
> correct and present in the kernel source.)

done.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
