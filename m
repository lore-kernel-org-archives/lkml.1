Return-Path: <linux-kernel-owner+w=401wt.eu-S1030553AbXHMOOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030553AbXHMOOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944229AbXHMLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:15:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:8285 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941179AbXHMLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=djwRXfchJy1M4r1MBOkYcDABI0hMmhKyRBu76/DcvcKZG8dxwTzJaEo88nOGbBTSRt6dWdpKmQzjTgvvegHLdpbyfeJMZO6n/3AzFEjWHYX7GKKVicC3REB2n1T3rTdVk8J/F4HU4T1PW7b46sdsrBPPDgPSq8D8zW5UiLh+7A0=
Message-ID: <9a8748490708130415j790d6e49y6ae12ca8dad780f2@mail.gmail.com>
Date: Mon, 13 Aug 2007 13:15:08 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: James.Smart@emulex.com
Subject: Re: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically allocated array
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>
In-Reply-To: <46C038E3.5090204@emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708130016.11281.jesper.juhl@gmail.com>
	 <200708130021.07068.jesper.juhl@gmail.com>
	 <46C038E3.5090204@emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, James Smart <James.Smart@emulex.com> wrote:
> NACK
>
> The fix is contained in our 8.2.2 sources recently posted and pushed by James
> as part of his last scsi fixes.
>

I actually did look for it, but couldn't find any lpfc commits with me
listed as author, so I assumed it had not been merged.
I just looked again, at the source this time, up-to-date mainline git
tree, and I still see

        hbqno = tag >> 16;
        if (hbqno > LPFC_MAX_HBQS)
                return NULL;

in drivers/scsi/lpfc/lpfc_sli.c

???


> -- james s
>
> Jesper Juhl wrote:
> > (previously send on 09-Aug-2007 20:47)
> >
> > Hi,
> >
> > The Coverity checker noticed that we may overrun a statically allocated
> > array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().
...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
