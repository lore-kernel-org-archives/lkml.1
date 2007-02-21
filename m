Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXBUKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXBUKAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXBUKAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:00:39 -0500
Received: from main.gmane.org ([80.91.229.2]:50756 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161187AbXBUKAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:00:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: [patch 03/18] Dont leak NT bit into next task
Date: Wed, 21 Feb 2007 11:00:15 +0100
Message-ID: <erh57g$oeb$1@sea.gmane.org>
References: <20070221014413.282048309@mini.kroah.org> <20070221014953.GD3684@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-220-198-109.cust-adsl.tiscali.it
User-Agent: KNode/0.10.4
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 02:49, Greg KH wrote:

>  /* frame pointer must be last for get_wchan */
> -#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
> +#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"

No idea if this is a problem or not, but you forgot a \n after popf.

-- 
Giuseppe "Oblomov" Bilotta

