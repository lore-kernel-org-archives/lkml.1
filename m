Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYJKPna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYJKPna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYJKPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:43:22 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50414 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYJKPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:43:22 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Sat, 11 Oct 2008 17:41:53 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810111929.01927.arvidjaar@mail.ru>
In-Reply-To: <200810111929.01927.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111741.53404.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 11. Oktober 2008 17:29:01 schrieb Andrey Borzenkov:
> Logically, one piece of kernel code has no way to know whether another
> piece of kernel code (or may be hard-/firmware) has disabled some
> interrupt line. So it looks like spin_lock_irq should not even exist,
> except may be for very specific cases (where we are sure no other piece
> of kernel code may run concurrently)?
> 
> Sorry for stupid question, I an not actually a HW type of person ...
> 

This has no connection with individual irq lines. It's about being able
to sleep. Kernel code usually knows whether it can sleep.
If it knows to be able to sleep it can use spin_lock_irq() which is
more efficient than spin_lock_irqsave()

	Regards
		Oliver

