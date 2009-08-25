Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZHYWyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZHYWyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbZHYWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:54:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:64527 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbZHYWyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="180126392"
Subject: Re: [PATCH] x86: use hard_smp_processor_id to get apic id in
 identify_cpu -v2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
In-Reply-To: <4A946082.9090809@kernel.org>
References: <4A9391CD.5020804@kernel.org>  <4A946082.9090809@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 25 Aug 2009 15:53:55 -0700
Message-Id: <1251240835.2636.28.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 15:06 -0700, Yinghai Lu wrote:
> 
> and leave phys_proc_id to use initial apic id.

No. We need to be consistent for both phys_proc_id and apicid
computations.

i.e., if the bios changes the apic id's and those updated apic id's are
not reflected in the initial apic id, then we need to use
hard_smp_processor_id() for both phys_proc_id and apicid computations.

On the other platforms (default option) we need to use initial apic id
(returned by cpuid).

> -v2: update the one in detect_extended_topology too.

This is not required. On these platforms, initial_apicid will be updated
(along with the physical apicid) if there are any bios modifications.

Instead of this patch, what we need to do is: Just like the vsmp change,
we need to override the phys_pkg_id routine for the platforms where the
bios will modify apic id's and where cpuid doesn't reflect the bios
modification (for example IBM x445 system etc)

thanks,
suresh

