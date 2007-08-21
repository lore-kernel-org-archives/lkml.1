Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXHUGHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXHUGHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXHUGHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:07:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:38208 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXHUGHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ch3DsGL7A8Oa6oUHuzPa3f3U4mRIjEZ8WPijXxP1w6eeq4edIOn6MX/d0ymcNNcwEqx56WIjuyqazBRQivdZBisNOk4RAjyTLGRiWQdPxROkytDYP2N2z1FQLSeGKRsWrwypAmqPNeQePUD9pIYCy8B8hQfCBTPDcktMr/KE1lU=
Message-ID: <21d7e9970708202306nda9be8dl2d305eb5a80bfcf8@mail.gmail.com>
Date: Tue, 21 Aug 2007 16:06:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: uncached page allocator
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220708200536r786ee72ere7522547c375a428@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220708200536r786ee72ere7522547c375a428@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Write-combining access seems the correct thing here, followed by a
> wmb(). Uncached writing would be horrendously slow.
>
> [snip]
> > So after all that I'd like to have some sort of uncached page list I
> > can allocate pages from
>
> This is exactly what Intel's PAT mechanism exists for - just mark the
> desired access type (index) on the pages you've been allocated.
>
> It's documented in the Intel Architecture Software Design manuals, but
> Linux's support is lacking in certain areas [discussions on LKML],
> which a number of developers have been trying to move forward.
>
> Quite a few significant graphics/HPC etc vendors are forced to use it
> without this complete support, so it would be good to get this
> additional impetus involved...

I'm hoping to pick up the PAT cause at some point soon this stuff is
definitely required to get any use out of modern graphics hardware.

It is slightly orthogonal to the issue I mentioned in that I still
have the problem of allocating uncached memory without the flushing
overheads associated with making pages cached/uncached constantly..

Dave.

>
> Daniel
> --
> Daniel J Blueman
>
