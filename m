Return-Path: <linux-kernel-owner+w=401wt.eu-S1161255AbXCHX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255AbXCHX5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161264AbXCHX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:57:24 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:39621 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161255AbXCHX5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:57:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fo0aVUoMwCQlAvj3tAQ4AHvKfUSKA5Z7aGb9T233wpey0Lm8sa9C/vQc64oFq8SZq1o+SmYVN+AHVysCw8PQZSqtR8IWIfOe0I/G3RffgNMNcMxh7lh2IG9Mu/3cXWvoPEcBGI3cv5x5/i3gqszMWcLKZl52VRCxiANv5Y6wtsE=
Message-ID: <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:57:22 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F09F9C.4030801@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	 <45F09F9C.4030801@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Nothing in the manuals says that write() on same fd should be non racy : In
> particular file pos might be undefined. There is a reason pwrite() exists.
>
> Kernel doesnt have to enforce thread safety as standard is quite clear.

I know the standard _allows_ us to crash and burn (well, corrupt
f_pos) when two threads race on an fd, but why would we want to?
Wouldn't it be better to do something at least slightly sane, like add
atomically to f_pos the expected number of number of bytes written,
then do the write, then fix it up (again atomically) if vfs_write
returns an unexpected pos?

> Only O_APPEND case is specially handled (and NFS might fail to handle this
> case correctly)

Is it?  How?
