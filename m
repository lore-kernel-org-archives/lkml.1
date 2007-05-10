Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbXEJNXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbXEJNXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760216AbXEJNXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:23:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:47451 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbXEJNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j0XHgWVSKJTD/U8fUN4bJs3Hhr9FJHxW8yaZKnfgfmSqcaTzum11Y9tUYx+bvQ0QP06tY75mXq45II+LWlLIJJXfSU3HN9dAGnYqVQ+NzwZb7VPxzaMAvqPopKpTdNeiBPZ4DSjnvbC7AS/GQ8p7Ri1kG0rPgzS0W54897mlaLk=
Message-ID: <a781481a0705100623s53730502kc5470b6dc6fc6a45@mail.gmail.com>
Date: Thu, 10 May 2007 18:53:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH 7/12] i386 sg: add support for chaining scatterlists
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <11787972373410-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
	 <11787972373410-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> [...]
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +                           struct scatterlist *sgl)
> +{
> +#ifndef ARCH_HAS_SG_CHAIN
> +       BUG();
> +#endif

Hmmm ... so we better also make sure all users call this from within
an "#ifdef ARCH_HAS_SG_CHAIN" themselves (or else make this a config
option defined in the arch/.../defconfig of archs that support this
and then make the calling code's Kconfig option "depends on ... &&
ARCH_FOO").

(Just saw a previous thread, Andrew seems to have beaten me to this observation)
