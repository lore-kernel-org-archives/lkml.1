Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZETXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZETXDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZETXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:03:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:59163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZETXDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:03:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,224,1241420400"; 
   d="scan'208";a="414336723"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A120B47.8060200@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
	 <1242674444.27006.8691.camel@localhost.localdomain>
	 <4A11B9E7.8010707@zytor.com>
	 <1242680835.27006.8734.camel@localhost.localdomain>
	 <4A120B47.8060200@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 20 May 2009 16:01:10 -0700
Message-Id: <1242860470.27006.10106.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 18:28 -0700, Tejun Heo wrote:
> Hello, Suresh.
> 
> Suresh Siddha wrote:
> > This %gs:absolute type accesses are for static percpu data.
> > 
> > But what I was referring to is the dynamic percpu data(accessed through
> > per_cpu_ptr()). Instead of combining some part of the dynamic percpu
> > data into  the static percpu data(first percpu chunk), we can use
> > different chunks for dynamic percpu data and governed by a different
> > per_cpu_dynamic_offset[NR_CPUS] array.
> > 
> > Then we can use large-page kernel direct mappings for static percpu data
> > (or %gs:offset) and small-page vmalloc mappings for dynamic percpu data.
> 
> Hmmm... I can't really follow what you're suggesting.  Can you please
> explain it in more detailed way?

Ok. Before I make another attempt walking that hill :)

I was talking to Peter and it seems there are some requests to change
the first percpu unit allocation for each possible cpu using bootmem
allocator, to allocating the corresponding unit at the cpu online time.

Do you have plans to change this? If we do this allocation during the
corresponding cpu online time and don't end up using big pages, then
also we avoid all these aliasing issues...

thanks,
suresh

