Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXCBDKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXCBDKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422792AbXCBDKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:10:22 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:46640 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422743AbXCBDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:10:22 -0500
Subject: Re: [PATCH RFC 0/5] hard_smp_processor_id overhaul
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
In-Reply-To: <20070301140648.GX26583@kvack.org>
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
	 <20070301140648.GX26583@kvack.org>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Fri, 02 Mar 2007 12:10:46 +0900
Message-Id: <1172805046.3362.20.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 09:06 -0500, Benjamin LaHaise wrote:
> On Thu, Mar 01, 2007 at 04:16:13PM +0900, Fernando Luis Vázquez Cao wrote:
> > As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> > systems (see "linux/smp.h") is not correct.
> > 
> > This patch-set does the following:
> > 
> > 1- Remove hardcoding of hard_smp_processor_id on UP systems.
> 
> NAK.  This has to be configurable, as many embedded systems don't even 
> have APICs.  Please rework the patch set so that there is not any overhead 
> for existing UP systems.
In i386 (with the exception of voyager) and x86_64,
hard_smp_processor_id is not used anywhere in the kernel when there are
no APICs available.

Regarding the overhead, hard_smp_processor_id is used mostly during
initialization and doesn't seem to be used in any fast path in i386,
x86_64, and ia64. All the other architectures are not affected by this
patch, because I kept the hardcoding of hard_smp_processor_id on UP
kernels, and just moved the definition to asm/smp.h because it should be
handled by architecture-speficic code.

So unless strictly necessary I would not like to make this patches
dependent on kdump.

