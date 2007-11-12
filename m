Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXKLP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXKLP7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXKLP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:59:43 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:61160 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbXKLP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:59:42 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Mon, 12 Nov 2007 16:56:14 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] x86: apicdef unification: some constants made
 unsigned
Message-ID: <20071112155614.GC18993@erda.amd.com>
References: <20071106183645.951275000@amd.com>
 <20071106183646.064906000@amd.com>
 <Pine.LNX.4.64N.0711121229360.30102@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64N.0711121229360.30102@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 12 Nov 2007 15:56:14.0860 (UTC)
 FILETIME=[8DE41CC0:01C82544]
X-WSS-ID: 6B26A82807S2230188-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.11.07 12:31:44, Maciej W. Rozycki wrote:
> > -#define			GET_APIC_VERSION(x)	((x)&0xFF)
> > -#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
> > -#define			APIC_INTEGRATED(x)	((x)&0xF0)
> > +#define			GET_APIC_VERSION(x)	((x)&0xFFu)
> > +#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
> > +#define			APIC_INTEGRATED(x)	((x)&0xF0u)
> 
>  No point in doing this -- hexadecimal literals are unsigned by 
> definition.  File a compiler bug if you see them interpreted otherwise.

My understanding from the c90/c99 standards is that hexadecimal
constants may result in signed or unsigned types. Contrarily, decimal
constants always result in integer types, if no signed suffix is
given.

However, I made this change only to unify 32 and 64 bit implementation
and took already existing code from the 64 bit version.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


