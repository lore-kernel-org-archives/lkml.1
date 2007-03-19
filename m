Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXCSIft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXCSIft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCSIft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:35:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31930 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCSIfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Hh6DmTtQ/5ue8dSqfOaIPMwzoivy2yM8Kn1+KrLDzjm4zhWl8wD06gAHfTMwngth7V9QfglTJJME0e9lj8l9+EgZwH9fP0JF3deG7Oq4ucw7Ytd7q71nashUDOLvuC3QGKvew8CZFwXCf7Lqa5hsqbXxepUKp/ZJMphh22QYsqY=
Message-ID: <84144f020703190135t40e7cebnfa4f8443f514c24d@mail.gmail.com>
Date: Mon, 19 Mar 2007 10:35:46 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Cc: "Andreas Steinmetz" <ast@domdv.de>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FDDA8E.8030100@domdv.de>
	 <20070318220006.7230fd58.akpm@linux-foundation.org>
	 <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
	 <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
X-Google-Sender-Auth: ca99fa3a6f66483d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> You can see that mempool_free is passing a NULL pointer to
> kmem_cache_free() which doesn't handle it properly. The NULL pointer
> comes from bio_free() where ->bi_io_vec is  NULL because nr_iovecs
> passed to bio_alloc_bioset() was zero.
>
> The question is, why is nr_pages zero in scsi_req_map_sg()?

Note that the following patch I posted only addresses the part where
slab is clearly failing here:

http://lkml.org/lkml/2007/3/19/42

So, while it should fix the oops, there might be a bug lurking in the
SCSI or block layer still.
