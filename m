Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYEOM6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYEOM6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYEOM6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:58:23 -0400
Received: from gw.goop.org ([64.81.55.164]:53225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYEOM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:58:23 -0400
Message-ID: <482C3360.1040309@goop.org>
Date: Thu, 15 May 2008 13:58:08 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: fix arbitrary_virt_to_machine()
References: <482C47B4.76E4.0078.0@novell.com>
In-Reply-To: <482C47B4.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> While I realize that the function isn't currently being used, I still
> think an obvious mistake like this should be corrected.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -60,7 +60,7 @@ xmaddr_t arbitrary_virt_to_machine(unsig
>  {
>  	unsigned int level;
>  	pte_t *pte = lookup_address(address, &level);
> -	unsigned offset = address & PAGE_MASK;
> +	unsigned offset = address & (PAGE_SIZE - 1);
>   

Yeah.  But I'd prefer "~PAGE_MASK".

    J
