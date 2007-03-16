Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbXCPTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbXCPTUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXCPTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:20:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:35182 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbXCPTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:20:40 -0400
Message-ID: <45FAEDFB.70103@ru.mvista.com>
Date: Fri, 16 Mar 2007 22:20:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6 -rt] powerpc 2.6.20-rt8: add preemption checks for
 NEED_RESCHED_DELAYED.
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi7itt25t5.wl@toshiba.co.jp>
In-Reply-To: <yyi7itt25t5.wl@toshiba.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tsutomu OWA wrote:
>   To add preemption checks for the NEED_RESCHED_DELAYED flag.

> diff -rup linux-rt8/arch/powerpc/kernel/idle.c rt/arch/powerpc/kernel/idle.c
> --- linux-rt8/arch/powerpc/kernel/idle.c	2007-02-20 14:30:38.000000000 +0900
> +++ rt/arch/powerpc/kernel/idle.c	2007-02-20 15:43:04.000000000 +0900
> @@ -56,7 +56,8 @@ void cpu_idle(void)
>  
>  	set_thread_flag(TIF_POLLING_NRFLAG);
>  	while (1) {
> -		while (!need_resched() && !cpu_should_die()) {
> +		while (!need_resched() && !need_resched_delayed() &&
> +				!cpu_should_die()) {
>  			ppc64_runlatch_off();
>  
>  			if (ppc_md.power_save) {

    Argh, I've missed this one! :-(
    But shouldn't we also add !need_resched_delayed() to another place below?

if (ppc_md.power_save)  {
[...]
	if (!need_resched() && !cpu_should_die())

WBR, Sergei
