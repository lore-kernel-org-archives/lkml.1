Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZFAFFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZFAFFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZFAFFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:05:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:3193 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZFAFFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mt/ExjhjdYfYcK+1ON2x40kbXtMtYjnrC7QI/B3zALGZcE0mBaMZmgGEW93Bf4rwkx
         nMxUw/EHNOfmynyYfcD6NSMB6BNlVihxI2F9YIGS1FpvXn8u1wCGI/nOCeetVQ5xOpI/
         DJJ0zBB/XTsplIETxw+VzMtT23Hl18pC1SzSo=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 13:05:47 +0800
Message-ID: <2674af740905312205v645b5ba1n76ea4f34cb4f8051@mail.gmail.com>
Subject: Re:[RFC/PATCH PATCH 6/6] lockdep: Consider the rw_state of lock while 
	validating the chain.
From: Yong Zhang <yong.zhang0@gmail.com>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<...>
>@@ -1767,9 +1773,15 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
>
> 		if (!ret)
> 			return 0;
>+
>+		if (ret != 2 && is_rec_read(hlock->rw_state))
>+			hlock->rw_state |= STATE_FIRST_RECURSIVE_READ;
>+
>+
> 		/*
> 		 * Add dependency only if this lock is not the head
>-		 * of the chain, and if it's not a secondary read-lock:
>+		 * of the chain, and if it's not the first instance of
>+		 * the recursive read-lock:

This change maybe don't show what you want to say.
Maybe it should be "or if it's the first instance of the recursive read-lock."

> 		 */
> 		if (!chain_head && ret != 2)
> 			if (!check_prevs_add(curr, hlock))
<...>
