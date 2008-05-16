Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYEPNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYEPNBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYEPNBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:01:09 -0400
Received: from gw.goop.org ([64.81.55.164]:43926 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYEPNBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:01:08 -0400
Message-ID: <482D8585.90909@goop.org>
Date: Fri, 16 May 2008 14:00:53 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: fix arbitrary_virt_to_machine()
References: <482C47B4.76E4.0078.0@novell.com> <482C3360.1040309@goop.org> <20080516120911.GE11718@elte.hu>
In-Reply-To: <20080516120911.GE11718@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  	unsigned int level;
>  	pte_t *pte = lookup_address(address, &level);
> -	unsigned offset = address & PAGE_MASK;
> +	unsigned offset = address & ~PAGE_SIZE;
>   

Ah, no, you have the worst of both worlds there ;)  Should be ~PAGE_*MASK*.

    J
