Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZCRMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZCRMZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZCRMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:25:30 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:33261 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640AbZCRMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:25:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Gb/QQY22SL7l1gRDi0s9I1G1SUcnvuVktFiR/N3K3Jxg3kZk9zjP/nBX1WQd4F6shfXjob+1PSA/j0EaZ9hSR9F8MUT641VDAbLClTaaT4FmTaWk8dFfYQsRFxpGZjUefskHPXm+cShp3EWKDgHvHJlWJyz++fGCUWWGpmuYIhc=  ;
X-YMail-OSG: NOSsPnoVM1mWIfsQXJtU4yGEsjusXlrvbDARzQzAs9gpGJqDa2o7oJlI2CFXbzCJLfYQuhhQySI2wQ9lB5Py_j0irwL54sTiz1EyBEG2ddzODInRRbqDQp7qnUe_rk_lHSkJJXWLyKUAKZ.a.PenNCUZSrI2spOGj9mBfhCX.iFr5_ACTJmAmyH_QY3O0o_Jfy1mIm6F_JQpP3cn_j3DQTd3JP9LXGgVxUmuGHg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: ngupta@vflare.org
Subject: Re: [PATCH 1/3]: compressed RAM block device
Date: Wed, 18 Mar 2009 23:25:20 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <49BF8ABC.6040805@vflare.org> <49BF8B4E.1030603@vflare.org>
In-Reply-To: <49BF8B4E.1030603@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903182325.21106.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 22:36:46 Nitin Gupta wrote:
>   drivers/block/Kconfig     |   22 +
>   drivers/block/Makefile    |    1 +
>   drivers/block/compcache.c |  995
> +++++++++++++++++++++++++++++++++++++++++++++ drivers/block/compcache.h | 
> 160 ++++++++
>   4 files changed, 1178 insertions(+), 0 deletions(-)
>
> Creates RAM based block device (ramzswap0) which can be used as swap
> device. Pages swapped to this are compressed and stored in memory itself.
>
> The module is called compcache.ko. It depends on:
>   - xvmalloc.ko: memory allocator
>   - lzo_compress.ko
>   - lzo_decompress.ko
>
> See Documentation/blockdev/compcache.txt for usage details.
>
> Project home: http://code.google.com/p/compcache/

I wonder how hard it would be to make the compression code
use an arbitrary file or device for the storage backend rather
than make a new block device? Then you could make a new ram
block device that can swap its pages out (or even extend brd.c
with that functionality, or use loop on tmpfs etc).



