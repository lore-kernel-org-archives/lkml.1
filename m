Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYJPXOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYJPXOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYJPXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:14:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46241 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbYJPXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=veR1MyWQB8VVh8Zm26MrfXAWIkyxZgUuwTFlVFcN4GE5pZbF189JW+P1Z/U/ztaKH9
         LP2TWsJW+gzisBhzXzYgoMBDajpdBCzDpdfNYj1J6wnoOBq39ApKSU8yGwV9PZNDK88l
         Ua2h+gpRpRjMVVpZO6UW3F3/usosIbs6qBeG0=
Date: Fri, 17 Oct 2008 03:17:36 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] cciss: fix regression in procfs display fw version,
	obsoletes previous patch 2 of 2
Message-ID: <20081016231736.GA7876@x200.localdomain>
References: <20081016215016.GB25704@roadking.ldev.net> <20081016145642.2ba2adba.akpm@linux-foundation.org> <0F5B06BAB751E047AB5C87D1F77A77884C019B4CBE@GVW0547EXC.americas.hpqcorp.net> <20081016223251.GA10270@x200.localdomain> <0F5B06BAB751E047AB5C87D1F77A77884C019B4CEF@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884C019B4CEF@GVW0547EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:56:58PM +0000, Miller, Mike (OS Dev) wrote:
> > > > +     return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
> > > > > +             sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
> > > > > +     if (return_code == IO_OK) {
> > > > > +             hba[i]->firm_ver[0] = inq_buff->data_byte[32];
> > > > > +             hba[i]->firm_ver[1] = inq_buff->data_byte[33];
> > > > > +             hba[i]->firm_ver[2] = inq_buff->data_byte[34];
> > > > > +             hba[i]->firm_ver[3] = inq_buff->data_byte[35];
> > > > > +     } else {         /* send command failed */
> > > > > +             printk(KERN_WARNING "cciss: unable to
> > > > determine firmware"
> > > > > +                     " version of controller\n");
> > > > > +     }
> > > > > +
> > > > >       cciss_procinit(i);
> > > > >
> > > > >       hba[i]->cciss_max_sectors = 2048;
> > >
> > > Sorry, in too much of a hurry. I'll fix (again).
> >
> > And inq_buff is leaked, if I'm not missing simething.
> >
> Sorry, Alexy, I can't see the leak. Is it in the failure case?

Where "inq_buff" is freed?
