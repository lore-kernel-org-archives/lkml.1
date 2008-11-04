Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYKDW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYKDW3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYKDW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:29:15 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:46288 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbYKDW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:29:14 -0500
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
From: Ben Hutchings <bhutchings@solarflare.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4910C845.4060909@kernel.org>
References: <4910C845.4060909@kernel.org>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 04 Nov 2008 22:29:08 +0000
Message-Id: <1225837748.3074.54.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 14:10 -0800, Yinghai Lu wrote:
> 
> Impact: so NR_IRQS is bigger enough for system with lots of apic/pins
> 
> Now: if IO_APIC is there, will have big NR_IRQS
> 
> otherwise still use 224
[...]

I have no idea whether this is useful, but it doesn't solve the general
problem that probe_nr_irqs() can return a value > NR_IRQS.  So far as I
can see it can return up to 2 * 24 * MAX_IO_APICS which may be greater
than NR_VECTORS + (32 * max(MAX_IO_APICS, NR_CPUS)).

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

