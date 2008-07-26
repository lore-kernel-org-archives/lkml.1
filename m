Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYGZKFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYGZKFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYGZKFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:05:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYGZKFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:05:32 -0400
Date: Sat, 26 Jul 2008 12:05:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/24] OProfile: Change IBS interrupt initialization
Message-ID: <20080726100518.GG25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-14-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-14-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> +static int pfm_amd64_setup_eilvt(void)
> +{
> +#define IBSCTL_LVTOFFSETVAL		(1 << 8)
> +#define IBSCTL				0x1cc

move this into a header file please.

> +	cpu_cfg = NULL;
> +	do {
> +		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
> +					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
> +					 cpu_cfg);
> +		if (!cpu_cfg)
> +			break;
> +		++nodes;
> +		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
> +				       | IBSCTL_LVTOFFSETVAL);
> +		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
> +		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
> +			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
> +				"IBSCTL = 0x%08x", value);
> +			return 1;
> +		}
> +	} while (1);

helper function for the iterator would help a bit i guess.

	Ingo
