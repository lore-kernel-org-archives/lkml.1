Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYHFRYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYHFRYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYHFRYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:24:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYHFRYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:24:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=in-reply-to:references:mime-version:content-type:message-id:cc:
	content-transfer-encoding:from:subject:date:to:x-mailer;
	b=CGEOhwpFELlkJL3v4jgUAMXbW4OMNeAdM0aVp+8DzaDsiftZWa2EsG/ITztbf90/2
	30Ns1/lYr3hwpTDeWTjlA==
In-Reply-To: <1218015158.4419.58.camel@sebastian.kern.oss.ntt.co.jp>
References: <1218015158.4419.58.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <D7ABD5F1-A0D8-4F80-AE0B-568A1E272CE0@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: Divyesh Shah <dpshah@google.com>
Subject: Re: request->ioprio
Date: Wed, 6 Aug 2008 10:22:30 -0700
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6, 2008, at 2:32 AM, Fernando Luis Vázquez Cao wrote:

> (CCing LKML)
>
> Hi Jens, Rusty,
>
> Trying to implement i/o tracking all the way up to the page cache (so
> that cfq and the future cgroup-based I/O controllers can schedule
> buffered I/O properly) I noticed that struct request's ioprio is
> initialized but never used for I/O scheduling purposes. Indeed there
> seems to be one single user of this member: virtio_blk. Virtio uses
> struct request's ioprio in the request() function of the virtio block
> driver, which just copies the ioprio value to the output header of
> virtblk_req.
>
> Is this the intended use of struct request's ioprio? Is it OK for  
> device
> drivers to use it? If the answer two the previous to questions is no I
> would like to send some clean-up patches.

Naveen Gupta sent a priority-based anticipatory IO scheduler patchset  
earlier which uses request->ioprio and the struct request seems to be  
the logical place to keep the ioprio. So, please don't cleanup the  
ioprio from there.

Thanks,
Divyesh

>
> - Fernando
>



