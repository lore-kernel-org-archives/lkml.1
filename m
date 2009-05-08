Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbZEHLSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbZEHLSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbZEHLRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:17:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbZEHLRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:17:42 -0400
Date: Fri, 8 May 2009 13:17:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 05/16] xen mtrr: Add mtrr_ops support for Xen mtrr
Message-ID: <20090508111703.GG11596@elte.hu>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org> <1241730653-4688-6-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241730653-4688-6-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> +/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
> + * working userland mtrr support. */
> +static struct mtrr_ops xen_mtrr_ops = {
> +	.vendor            = X86_VENDOR_UNKNOWN,
> +//	.set               = xen_set_mtrr,
> +//	.get               = xen_get_mtrr,
> +	.get_free_region   = generic_get_free_region,
> +//	.validate_add_page = xen_validate_add_page,
> +	.have_wrcomb       = positive_have_wrcomb,
> +	.use_intel_if	   = 0,
> +	.num_var_ranges	   = xen_num_var_ranges,
> +};

Please dont post patches with ugly TODO items in them.

Also, a more general objection is that /proc/mtrr is a legacy 
interface, we dont really want to extend its use. The Xen hypervisor 
should get proper PAT support instead ...

	Ingo
