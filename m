Return-Path: <linux-kernel-owner+w=401wt.eu-S1766856AbXEBTzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766856AbXEBTzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766875AbXEBTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:55:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:42294 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766856AbXEBTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Jf4rNOALa6VkdlvJ2xAUUB1B3BGYIWnGbkg5eYx45E3OGFOU0w2pb7/W33FLGUsEI817F+okmcYxN8bFIh+Vs+qprL4zh4T3ljdX8DtAy0LQKHws8HYj4GqzJvvea1apr+yG91iFgh8oe7efHhGpLkj4FesvQPDHpDAi2bPVnQw=
Date: Thu, 3 May 2007 03:59:31 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [RELEASE] Lguest for 2.6.21
Message-ID: <20070502195931.GB1502@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>
References: <1178117028.19815.14.camel@localhost.localdomain> <20070502193303.GA1502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502193303.GA1502@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:33:03AM +0800, WANG Cong wrote:
>Hi Rusty!
>
>I found you forgot to check the return value of copy_from_user, and here is the fix for drivers/lguest/interrupts_and_traps.c.
>

Also this one, in drivers/lguest/hypercalls.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

--- linux-2.6.21-rc7-mm2/drivers/lguest/hypercalls.c.orig	2007-05-03 03:45:53.000000000 +0800
+++ linux-2.6.21-rc7-mm2/drivers/lguest/hypercalls.c	2007-05-03 03:46:20.000000000 +0800
@@ -102,7 +102,8 @@ static void do_async_hcalls(struct lgues
 	unsigned int i;
 	u8 st[LHCALL_RING_SIZE];
 
-	copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st));
+	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+		return;
 	for (i = 0; i < ARRAY_SIZE(st); i++) {
 		struct lguest_regs regs;
 		unsigned int n = lg->next_hcall;
