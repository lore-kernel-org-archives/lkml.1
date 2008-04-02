Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYDBOrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYDBOrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYDBOro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:47:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:51697 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYDBOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l670nKtIl2bA1dfvdS5KK51r8SnygMZQ9nLfLSRUhabGAOikzLrOUC/v7XAdxyek6ILKUe8h4mdJUYTzDniz//+8PeonX36LEJmk7X3W4+J3LJTNyd/MzRRm18dkYXBxnxQpug3I2yf1yPxp991X8O+c4yzRuw0r/yCutEWsDgg=
Message-ID: <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>
Date: Wed, 2 Apr 2008 10:47:33 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than kernel
Cc: "Greg Ungerer" <gerg@snapgear.com>,
       "David McCullough" <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, "Bryan Wu" <Bryan.Wu@analog.com>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
In-Reply-To: <5516.1207146014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
	 <5516.1207146014@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 10:20 AM, David Howells <dhowells@redhat.com> wrote:
> Mike Frysinger <vapier.adi@gmail.com> wrote:
>  > a workaround: introduce a new no-mmu-only mmap flag MAP_UNINITIALIZE
>  > to signal to the kernel that it should skip the memset().  this way,
>  > userspace malloc() can do mmap(MAP_ANONYMOUS|MAP_UNINITIALIZE) to get
>  > large chunks of memory without affecting any other anonymous mmap()
>  > call.
>
>  I think that's reasonable for NOMMU.  It's not like the process accessing the
>  uninitialised memory is prevented from accessing anything it wants to anyway.
>
>  I would vote that the memset() should only be skipped if requested as there
>  may be programs that call mmap(MAP_ANONYMOUS) expecting the memory they're
>  given to be zeroed out.

in the second proposal, the C library would be expected to do this, so
no programs would be broken.  but you're right that any program that
invokes the mmap() syscall directly would not get zeroed memory ...
but is anyone doing such a crazy thing, let alone on embedded ?
-mike
