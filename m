Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbZDBTaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbZDBTaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZDBT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:29:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbZDBT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:29:58 -0400
Date: Thu, 2 Apr 2009 21:29:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: markus.t.metzger@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/18] x86, ds: use single debug store cpu configuration
Message-ID: <20090402192942.GE2455@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145728.179163000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402145728.179163000@intel.com>
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


* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:

> Use a single configuration for all cpus.
> 

> @@ -1291,11 +1290,15 @@ ds_configure(const struct ds_configurati
>  	printk("bts/pebs record: %u/%u bytes\n",
>  	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
>  
> -	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
> +	WARN_ON(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));

Why this change?

Firstly, it was not declared in the changelog which is a no-no. 

Secondly, this is a bad change: we are more than content to have a 
single such warning bootup - not dozens of it (on some large 
system).

	Ingo
