Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXCOJxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXCOJxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXCOJxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:53:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:13676 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463AbXCOJxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DWXPU2QxM5Ox1eTGyu6pAoIGStjJG15Mcxj1srbpAG6zVp6dvH881kGXZh0PkPiTL8yv3YI+nj50x6aQBdpXP7qntbUY0jFZt36Jq9ZzYkzRAeakp3/ygvN4jTLTUVqSKqIwp21q0RIYBnAuV3FJth6Y0B0M3WRwn9Oysk/BbgA=
Message-ID: <b647ffbd0703150253q36d19c4ej8fe19ed644520017@mail.gmail.com>
Date: Thu, 15 Mar 2007 10:53:13 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: kernel/irq/proc.c] unprotected iteration over the IRQ action list in name_unique()
In-Reply-To: <b647ffbd0703140926v1aa861alecd1a2eb4c6d0f5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0703140926v1aa861alecd1a2eb4c6d0f5d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 1-st issue:  unprotected iteration over the IRQ action list in name_unique()
>
>
> the racing sequences:
>
> [ 1 ]  request_irq() -> setup_irq() -> register_handler_proc() ->
> name_unique() -> iterate over the action list (*)
>
> setup_irq() releases a desc->lock before calling register_handler_proc().
>
> [ 2 ]  free_irq() -> delete some element while (*) is still in progress -> bum!

"delete" == remove from the list + kfree() as synchronize_irq() is not
going to prevent it for obvious reasons.

Of course, request_irq() and free_irq() are called for the same
/shared/ irq line but for /different/ handlers.

Looks too obvious to be true. I already expected someone prooving me
wrong, at the very least by pointing out a special option of vim to
activate some hidden synchronization code :o)


-- 
Best regards,
Dmitry Adamushko
