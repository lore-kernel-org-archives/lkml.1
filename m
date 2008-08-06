Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbYHFQny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbYHFQny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYHFQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:43:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403AbYHFQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FHXJ53c0gAt8u0TSC8BX9kudP5JcIFEhO3sllE9TtpzpH/ovKenaf29FFbaqSlxzTR
         EcUbbU4ALJKabb7klFRhknDNvJvRtJDHDOxSndvhz1xzfMUcCmVvTLveNbSoglzd19jY
         FYrsE4zeA26d9PVn0oASEutobOLoA58j8DQcc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy: use scatterlists for pio transfers
Date: Wed, 6 Aug 2008 18:05:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080805051113.GA15834@gollum.tnic>
In-Reply-To: <20080805051113.GA15834@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808061805.01126.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 05 August 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's my first stab at using scatterlists in ide-floppy. I've adapted your
> ide-scsi version to fit in here. The change here is that i use pc->b_count as
> a sort-of completion counter to know when i'm at the end of the sg element and
> be able to switch to the next/finish transfer. I've tested the patch with the
> Iomega ZIP drive i have here - it works. We should do some more testing first
> though, before sending it upstream.

[...]

> @@ -569,7 +577,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
>  	memcpy(rq->cmd, pc->c, 12);
>  
>  	pc->rq = rq;
> -	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
> +	pc->b_count = 0;
>  	if (rq->cmd_flags & REQ_RW)
>  		pc->flags |= PC_FLAG_WRITING;
>  	pc->buf = NULL;

Don't we also need to zero pc->b_count in idefloppy_blockpc_cmd()?

[ idefloppy_init_pc() clears whole pc so ->b_count assignment
  to zero is not strictly necessary ]

Except that it looks all good, thanks for working on it.
