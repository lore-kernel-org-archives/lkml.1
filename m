Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYFSWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYFSWYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYFSWYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:24:31 -0400
Received: from gw.goop.org ([64.81.55.164]:55560 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYFSWYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:24:30 -0400
Message-ID: <485ADC73.60009@goop.org>
Date: Thu, 19 Jun 2008 15:23:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
In-Reply-To: <485ADA12.5010505@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> @@ -132,6 +133,12 @@ ident_complete:
>  #ifdef CONFIG_SMP
>  	addq	%rbp, trampoline_level4_pgt + 0(%rip)
>  	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
> +
> +	/*
> +	 * Fix up per_cpu__gdt_page offset when basing percpu
> +	 * variables at zero.  This is only needed for the boot cpu.
> +	 */
> +	addq	$__per_cpu_load, early_gdt_descr_base
>   

This needs to be rip-relative.  An absolute reference here will fail 
because you're still running in physical addresses.

    J
