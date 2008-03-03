Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYCCRkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYCCRkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762787AbYCCRdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:33:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:58499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762782AbYCCRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:33:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vyAuQRYKSHHzGB9o4zYU0QzEpWSRfzDzDtFK46KFVg8JJOMq6uwHOmzZPHCB1wrGo
	dAaBzfSv6iRNvURDkGaIg==
Message-ID: <da824cf30803030933j5647b0d4k61f6d110ff9f29bb@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:33:15 -0800
From: "Grant Grundler" <grundler@google.com>
To: "Hannes Reinecke" <hare@suse.de>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Cc: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
In-Reply-To: <47CC2652.1080601@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
	 <47CC2652.1080601@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 8:24 AM, Hannes Reinecke <hare@suse.de> wrote:

>  I would rather have rq->complete_io() to be pointing to blk_end_io in the
>  default case, this way rq->complete_io() would always be valid and we
>  would be saving us the if() clause.

This is a good idea. But...

...
>  So when using my proposal this would just become:
>
>  {
>     BUG_ON(!rq->complete_io);
>
>     return rq->complete_io(rq, error, nr_bytes, 0, NULL);
>  }

This "BUG_ON" is also an "if()" clause except
it will panic. The box will panic if the function
pointer is a null pointer and it won't be hard to
sort out why. I suggest omitting the BUG_ON.

thanks,
grant
