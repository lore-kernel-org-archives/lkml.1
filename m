Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab0BYLeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:34:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab0BYLeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:34:02 -0500
Date: Thu, 25 Feb 2010 12:33:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mrst] x86, pic: Introduce legacy_pic abstraction
Message-ID: <20100225113348.GF10212@elte.hu>
References: <43F901BD926A4E43B106BF17856F07559FB80D03@orsmsx508.amr.corp.intel.com>
 <tip-ef3548668c02cc8c3922f4423f32b53e662811c6@git.kernel.org>
 <43F901BD926A4E43B106BF17856F0755A318D2CD@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318D2CD@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> +static struct irq_chip dummy_pic_chip = {
> +	.name = "dummy pic",
> +	.mask = legacy_pic_uint_noop,
> +	.unmask = legacy_pic_uint_noop,
> +	.disable = legacy_pic_uint_noop,
> +	.mask_ack = legacy_pic_uint_noop,
> +};
> +static int legacy_pic_irq_pending_noop(unsigned int irq)
> +{
> +	return 0;
> +}
> +
> +struct legacy_pic null_legacy_pic = {
> +	.nr_legacy_irqs = 0,
> +	.chip = &dummy_pic_chip,
> +	.mask_all = legacy_pic_noop,
> +	.restore_mask = legacy_pic_noop,
> +	.init = legacy_pic_int_noop,
> +	.irq_pending = legacy_pic_irq_pending_noop,
> +	.make_irq = legacy_pic_uint_noop,
> +};
> +
> +struct legacy_pic default_legacy_pic = {
> +	.nr_legacy_irqs = NR_IRQS_LEGACY,
> +	.chip  = &i8259A_chip,
> +	.mask_all  = mask_8259A,
> +	.restore_mask = unmask_8259A,
> +	.init = init_8259A,
> +	.irq_pending = i8259A_irq_pending,
> +	.make_irq = make_8259A_irq,
> +};

Just a reminder: please use the vertical alignment style you can see with new 
pic/irqchip drivers:

struct irq_chip i8259A_chip = {
	.name		= "XT-PIC",
	.mask		= disable_8259A_irq,
	.disable	= disable_8259A_irq,
	.unmask		= enable_8259A_irq,
	.mask_ack	= mask_and_ack_8259A,
};

Thanks,

	Ingo
