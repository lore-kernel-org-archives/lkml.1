Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbZEMNOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbZEMNOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZEMNOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:14:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZEMNOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:14:35 -0400
Date: Wed, 13 May 2009 15:14:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090513131405.GB21052@elte.hu>
References: <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <4A09C068.3010308@kernel.org> <20090512183302.GA4000@elte.hu> <4A09C157.7010407@kernel.org> <20090512190538.GA9769@elte.hu> <4A09CCBB.2000306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09CCBB.2000306@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> -	return hard_smp_processor_id() >> index_msb;
> +	return initial_apic_id >> index_msb;

> -	unsigned apicid = hard_smp_processor_id();
> +	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;

> -	int apicid = hard_smp_processor_id();
> +	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;

Doesnt such a pattern call for the pushing of that distinction into 
hard_smp_processor_id() instead? (after a careful review of all 
hard_smp_processor_id() call-sites)

	Ingo
