Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbYIWLDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbYIWLDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYIWLDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:03:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbYIWLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:03:23 -0400
Date: Tue, 23 Sep 2008 13:03:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV
Message-ID: <20080923110316.GB29021@elte.hu>
References: <20080922211051.GG222374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922211051.GG222374@sgi.com>
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


* Russ Anderson <rja@sgi.com> wrote:

> +struct kobject *sgi_uv_kobj;

should be static?

> +static int __init sgi_uv_sysfs_init(void)
> +{
> +	if (!sgi_uv_kobj)
> +		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
> +	if (!sgi_uv_kobj) {
> +		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed \n");
> +		return -EINVAL;
> +	}
> +
> +	sysfs_create_file(sgi_uv_kobj, &partition_id_attr.attr);
> +	sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);

missing checks for failure?

	Ingo
