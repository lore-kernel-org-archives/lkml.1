Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZEDWAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZEDWAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZEDWAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:00:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZEDWAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:00:38 -0400
Message-ID: <49FF6532.7040206@redhat.com>
Date: Mon, 04 May 2009 18:59:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask
 in a family-specific way
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-10-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-10-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> +	for (cs = 0; cs < CHIPSELECT_COUNT; cs++) {
> +		reg = K8_DCSB0 + (cs * 4);
> +		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
> +						&pvt->dcsb0[cs]);
> +		if (err != 0)
> +			debugf0("%s() Reading K8_DCSB0[%d] failed\n",
> +				__func__, cs);
> +
> +		debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
> +			cs, pvt->dcsb0[cs], reg);
>   

Hmm... I suspect that there's a missing else before the debugf0(). If 
you got an error while reading it, you shouldn't be showing the results. 
> +
> +		/* If DCT are NOT ganged, then read in DCT1's base */
> +		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
> +			reg = F10_DCSB1 + (cs * 4);
> +			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
> +							&pvt->dcsb1[cs]);
> +			if (err != 0)
> +				debugf0("%s() Reading F10_DCSB1[%d] failed\n",
> +					__func__, cs);
> +			debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
> +				cs, pvt->dcsb1[cs], reg);
>   
The same issue here: if you got an error while reading it, you shouldn't 
be showing the results. 

Cheers,
Mauro.
