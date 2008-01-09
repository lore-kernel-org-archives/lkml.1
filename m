Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYAIBUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYAIBUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbYAIBUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:20:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:45596 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbYAIBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RFz3lUoQKGVTmQnJTP182SZ60fWtH5T9DyKZrCeObfYIQJRhhZVU/F+A0qpoWeK3w2RvrR/c59/7l9cSKwhr3ZCVzhmN0PLxYGqQLME+uXDo8clSskJkFbJB25Q4cTenERwUolY8Zg61IH01AtFkSxbsx0yd6mlbqRgNmOwDVD0=
Message-ID: <412e6f7f0801081720i61bf2986md68d19db11685218@mail.gmail.com>
Date: Wed, 9 Jan 2008 09:20:08 +0800
From: "Changli Gao" <xiaosuo@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Improve scalability of epoll_ctl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73k5mkqmrx.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478397F7.1030005@gmail.com> <p73k5mkqmrx.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 12:56 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Are you sure it's faster? vmalloc/vfree can be quite slow because
> they have to change the MMU state of the kernel and take global
> locks.
I don't think so. In fact, the memory of fdtable is allocated by
vmalloc when its size is bigger than PAGE_SIZE:

static inline void * alloc_fdmem(unsigned int size)
{
    if (size <= PAGE_SIZE)
        return kmalloc(size, GFP_KERNEL);
    else
        return vmalloc(size);
}

>
> The other problem is that on 32bit systems vmalloc space is somewhat
> limited -- you might have added an unintended scaling limit.

As I have talked above, I am sure open(), socket() and etc. will first
encounter it.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
