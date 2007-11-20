Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXKTP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXKTP0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXKTP0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:26:47 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:59651 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXKTP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:26:47 -0500
Date: Tue, 20 Nov 2007 07:26:46 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, ak@suse.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com>
Message-ID: <alpine.DEB.0.99999.0711200708580.765@twinlark.arctic.org>
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Metzger, Markus T wrote:

> +__cpuinit void ptrace_bts_init_intel(struct cpuinfo_x86 *c)
> +{
> +	switch (c->x86) {
> +	case 0x6:
> +		switch (c->x86_model) {
> +#ifdef __i386__
> +		case 0xD:
> +		case 0xE: /* Pentium M */
> +			ptrace_bts_ops = ptrace_bts_ops_pentium_m;
> +			break;
> +#endif /* _i386_ */
> +		case 0xF: /* Core2 */
> +			ptrace_bts_ops = ptrace_bts_ops_core2;
> +			break;
> +		default:
> +			/* sorry, don't know about them */
> +			break;
> +		}
> +		break;
> +	case 0xF:
> +		switch (c->x86_model) {
> +#ifdef __i386__
> +		case 0x0:
> +		case 0x1:
> +		case 0x2:
> +		case 0x3: /* Netburst */
> +			ptrace_bts_ops = ptrace_bts_ops_netburst;
> +			break;
> +#endif /* _i386_ */
> +		default:
> +			/* sorry, don't know about them */
> +			break;
> +		}
> +		break;

is this right?  i thought intel family 15 models 3 and 4 supported amd64
mode...

-dean
