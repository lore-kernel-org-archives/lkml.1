Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYKHWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYKHWMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYKHWMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:12:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:40918 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYKHWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=h4gdi6d5/TG8NbsvpeEC5WCS84sytE/1FI9G1/+IchBiSNX0IX1ObPtIg3jPSt/DSr
         yr0ZQ8kZNL6nmoEPpoW9UMGFAwp2lqrJZ3+cNHCSOtUpBSDo8ThIJNZK4JEh9JdU5PS8
         vavrhCwqzFEH1rMgdxw2sZj70Axw+22z6HXOw=
Message-ID: <86802c440811081412u6d54beaam143801ce83225f40@mail.gmail.com>
Date: Sat, 8 Nov 2008 14:12:28 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
Cc: "Linus Torvalds" <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "Andrew Morton" <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
X-Google-Sender-Auth: dc2b184c6cd00b62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 8:31 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> From 819ad3ed4660f4238e053728a8b5aa93d22b13d7 Mon Sep 17 00:00:00 2001
> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Tue, 4 Nov 2008 10:13:53 -0600
> Subject: [PATCH 1/1] irq: Maintain user set affinity
>
> This addresses a regression in that if a user specified an affinity
> for an interrupt that affinity information would get reset between
> a request_irq(), free_irq() and request_irq() for the same irq.
>
> On example of this is bringing up an ethernet interface, taking
> it down and bringing it back up again.
>
> Instead of always using the irq_default_affinity we use the
> previous setting of the IRQs affinity with the assumption that
> at boot the IRQs affinity will be set to irq_default_affinity.

why ?, the default_affinity is expected behavior...

for example: when MSI is used, second driver could get same irq if
first driver is unloaded.

YH
