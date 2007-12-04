Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXLDTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXLDTVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXLDTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:21:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:39383 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXLDTVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:21:36 -0500
Message-ID: <4755A809.4050305@qumranet.com>
Date: Tue, 04 Dec 2007 21:18:33 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com>
In-Reply-To: <11967844071346-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This patch moves the i386 control registers manipulation functions,
> wbinvd, and clts functions to system.h. They are essentially the same
> as in x86_64, except for the cr8 register, which we add.
>
> +
> +static inline unsigned long native_read_cr8(void)
> +{
> +	unsigned long cr8;
> +	asm volatile("mov %%cr8,%0" : "=r" (cr8), "=m" (__force_order));
> +	return cr8;
> +}
> +
>   

There is no cr8 register on i386.  This had better be protected by an 
#ifdef.

(you're likely not getting an error since it's a static inline, so the 
asm is never emitted)

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

