Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYJ3ECK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYJ3ECK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYJ3EB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:01:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:48357 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYJ3EBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v3HMCR2Hh80A9f4JNfKmPxAZYZqdDbjbscX85ubg2adaUripce7/DFqJwsP4tjd7mr
         +st91Tm/IHP10y8cGgFen25Tz/Me9qENzQscNksXgkdsazqeLkwXrxQuLLaOOLUH43vk
         cFfzQc6aFsZtvSO0ZLXTC+BATJJsRJZkZwCkU=
Message-ID: <b9df5fa10810292101o4ac4a67n77681a198b06311d@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:01:53 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resource.c: Fixing section mismatch warning .
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <b9df5fa10810292035p4c5a70eay44efae337a38d067@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10810292035p4c5a70eay44efae337a38d067@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/08, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>  LD      kernel/built-in.o
>  WARNING: kernel/built-in.o(.text+0xfcad): Section mismatch in
>  reference from the function reserve_region_with_split() to the
>  function .init.text:__reserve_region_with_split()
>  The function reserve_region_with_split() references
>  the function __init __reserve_region_with_split().
>  This is often because reserve_region_with_split lacks a __init
>  annotation or the annotation of __reserve_region_with_split is wrong.
>
>  This patch fixes the above warning.
>
I'm sorry. This problem has been fixed. I should've check this before
sending this patch.
Again, sorry.
>  Thanks.
>
>  Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
>
>  --- linux-2.6-orig/kernel/resource.c    2008-10-28 20:52:38.000000000 +0600
>  +++ linux-2.6/kernel/resource.c 2008-10-28 22:34:44.000000000 +0600
>  @@ -571,7 +571,7 @@ static void __init __reserve_region_with
>
>   }
>
>  -void reserve_region_with_split(struct resource *root,
>  +void __init reserve_region_with_split(struct resource *root,
>                 resource_size_t start, resource_size_t end,
>                 const char *name)
>   {
>
