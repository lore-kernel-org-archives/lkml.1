Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZL0Vuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZL0Vuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZL0Vui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:50:38 -0500
Received: from www84.your-server.de ([213.133.104.84]:42735 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZL0Vuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:50:37 -0500
Subject: Re: [PATCH] [6/6] kfifo: Document everywhere that size has to be
 power of two
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227210316.B116EB17C3@basil.firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210316.B116EB17C3@basil.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:50:32 +0100
Message-ID: <1261950632.25298.33.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> On my first try using them I missed that the fifos need to 
> be power of two, resulting in a runtime bug. Document that requirement
> everywhere (and fix one grammar bug)
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 

Acked: Stefani Seibold <Stefani@Seibold.net>

> ---
>  include/linux/kfifo.h |    4 ++--
>  kernel/kfifo.c        |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/include/linux/kfifo.h
> ===================================================================
> --- linux.orig/include/linux/kfifo.h
> +++ linux/include/linux/kfifo.h
> @@ -67,7 +67,7 @@ struct kfifo {
>  /**
>   * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
>   * @name: name of the declared kfifo datatype
> - * @size: size of the fifo buffer
> + * @size: size of the fifo buffer. Must be a power of two.
>   *
>   * Note1: the macro can be used inside struct or union declaration
>   * Note2: the macro creates two objects:
> @@ -91,7 +91,7 @@ union { \
>  /**
>   * DEFINE_KFIFO - macro to define and initialize a kfifo
>   * @name: name of the declared kfifo datatype
> - * @size: size of the fifo buffer
> + * @size: size of the fifo buffer. Must be a power of two.
>   *
>   * Note1: the macro can be used for global and local kfifo data type variables
>   * Note2: the macro creates two objects:
> Index: linux/kernel/kfifo.c
> ===================================================================
> --- linux.orig/kernel/kfifo.c
> +++ linux/kernel/kfifo.c
> @@ -41,7 +41,7 @@ static void _kfifo_init(struct kfifo *fi
>   * kfifo_init - initialize a FIFO using a preallocated buffer
>   * @fifo: the fifo to assign the buffer
>   * @buffer: the preallocated buffer to be used.
> - * @size: the size of the internal buffer, this have to be a power of 2.
> + * @size: the size of the internal buffer, this has to be a power of 2.
>   *
>   */
>  void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)


