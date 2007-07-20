Return-Path: <linux-kernel-owner+w=401wt.eu-S938187AbXGTPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938187AbXGTPqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXGTPqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:46:39 -0400
Received: from gw.goop.org ([64.81.55.164]:38728 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbXGTPqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:46:38 -0400
Message-ID: <46A0D8A1.8030904@goop.org>
Date: Fri, 20 Jul 2007 08:45:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: compudj@krystal.dyndns.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/11] x86: Stop MCEs and NMIs during code patching
References: <20070720532.949522000@suse.de> <20070720153247.75CAD14E7C@wotan.suse.de>
In-Reply-To: <20070720153247.75CAD14E7C@wotan.suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> +void stop_nmi(void)
> +{
> +	ignore_nmis++;
> +	acpi_nmi_disable();
> +}
> +
> +void restart_nmi(void)
> +{
> +	ignore_nmis--;
> +	acpi_nmi_enable();
> +}
>   

Wouldn't it be better to just assign ignore_nmis rather than inc/dec it
(and perhaps BUG on a double stop or restart)?  Also, is
acpi_nmi_disable/enable's use of on_each_cpu safe with interrupts
disabled if we know there's only one CPU alive at this point?

    J
