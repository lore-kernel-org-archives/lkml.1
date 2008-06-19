Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYFSDJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYFSDJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYFSDJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:09:24 -0400
Received: from elcamino.pasemi.com ([67.155.108.98]:38582 "EHLO
	elcamino.pasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYFSDJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:09:23 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 23:09:23 EDT
X-Spam-Flag: NO
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>
Message-Id: <BD25BA47-04A5-4FF7-86FD-959BCDB898A0@lixom.net>
From: Olof Johansson <olof@lixom.net>
To: Nathan Lynch <ntl@pobox.com>
In-Reply-To: <1213835374-10868-4-git-send-email-ntl@pobox.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: [RFC/PATCH 3/3] adjust cpu power for secondary threads on POWER6
Date: Wed, 18 Jun 2008 21:58:59 -0500
References: <1213835374-10868-1-git-send-email-ntl@pobox.com> <1213835374-10868-4-git-send-email-ntl@pobox.com>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +static unsigned int pseries_cpu_power(int cpu, unsigned int  
> default_power)
> +{
> +	struct device_node *np;
> +	unsigned int thread, power;
> +
> +	if (!cpu_has_feature(CPU_FTR_ASYM_POWER))
> +		return default_power;
> +
> +	power = default_power;

Why not just NULL out the cpu_power function pointers on platforms  
that don't have the feature bit instead? (or the other way around:  
NULL by default, and set only on platforms that have imbalanced threads.

It'd be even nicer to do so without using up a cpu feature bit, since  
it'd then only be used in determining whether to set the ppc_md  
function pointer or not, but I don't know if there's a convenient way  
to probe for this at runtime (cpu device tree node properties?).


-Olof

