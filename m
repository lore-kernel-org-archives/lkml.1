Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYFCGGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYFCGGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYFCGG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:06:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3560 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYFCGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W4KRONA0IJXit4sUZaxTrfVwvEFJNoKOs150K8BrROtFi4Tn39dUZUK36/mHm2vPYauynKTBz/MB+csmcTTul0kq5uzzoMST6EX5pAlymwJcwJbIkXIPPDEI5PUWTdMUb9oJsD4v52gV62k4i6BmJlFtjVsC7Cu6ZedT0ChW0ac=
Message-ID: <84144f020806022306h236a48cbv32b82cfa83fe4ee6@mail.gmail.com>
Date: Tue, 3 Jun 2008 09:06:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
X-Google-Sender-Auth: 5def1bcb735b8c1e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 8:02 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> Is there a reason we duplicate alloc/free_thread_info defines on many
> platforms?

No. The patch looks good.

On Tue, Jun 3, 2008 at 8:02 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> Note:
>
> - I don't like __HAVE_ARCH_THREAD_INFO_ALLOCATOR name much. I chose
> that name just because we define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR in
> the same place.
>
> - frv, m32r, mips, mn10300, and sh uses kmalloc/kfree instead of
> __get_free_pages/free_pages. I let them alone but it could remove more
> code if __get_free_pages/free_pages works for them.

Yeah, I too have wondered why some architectures use kmalloc() whereas
others use the page allocator. Is THREAD_SIZE significantly smaller
than PAGE_SIZE for those?
