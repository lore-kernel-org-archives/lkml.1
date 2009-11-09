Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZKISR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZKISR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZKISR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:17:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:18965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZKISR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:17:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,710,1249282800"; 
   d="scan'208";a="512118955"
Subject: Re: [PATCH v5] x86: under bios control, restore AP's APIC_LVTTHMR
 to the BSP value
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091109145148.GA15170@ywang-moblin2.bj.intel.com>
References: <20091109145148.GA15170@ywang-moblin2.bj.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 09 Nov 2009 10:16:34 -0800
Message-Id: <1257790594.2728.3.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 06:51 -0800, Yong Wang wrote:
>  
> +void mcheck_intel_therm_init(void)
> +{
> +	/*
> +	 * This function is only called on boot CPU. Save the init thermal
> +	 * LVT value on BSP and use that value to restore APs' thermal LVT
> +	 * entry BIOS programmed later
> +	 */
> +	lvtthmr_init = apic_read(APIC_LVTTHMR);
> +}

We shouldn't unconditionally read this LVT entry. We should qualify it
based on the presence of TM1 or TM2 capability, as this LVT entry is
implementation specific and not architectural.

thanks,
suresh 

