Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZEKJUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZEKJUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZEKJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:20:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZEKJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:20:45 -0400
Date: Mon, 11 May 2009 11:20:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] x86: read apic id if it is not acpi_lapic -v2
Message-ID: <20090511092026.GA26444@elte.hu>
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org> <20090502070254.GA4791@lenovo> <49FC85A9.2070702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FC85A9.2070702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0079]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> +	new_apicid  = read_apic_id();
> +	if (boot_cpu_physical_apicid != new_apicid) {
> +		boot_cpu_physical_apicid  = new_apicid;
> +		apic_version[new_apicid] =
> +			 GET_APIC_VERSION(apic_read(APIC_LVR));
>  	}

_Please_, when we override something as critical as this and change 
the behavior of Linux (even if it's arguably a fix), we must printk 
a single line to the syslog so that people know what's going on.

You really need to make a conscious mental distinction between 
'dangerous' code and harmless changes, and apply a lot more 
conservative approach when you meet and touch (and introduce ...) 
dangerous code.

Thanks,

	Ingo
