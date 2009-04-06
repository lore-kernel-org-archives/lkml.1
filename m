Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZDFUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZDFUMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDFUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:12:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:48150 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZDFUMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=oi8br4GCR7WevLvDg9MFc3tceU5W78Ue25piWF70JNib52qhJhi/IxSSZnJeUkiAeF
         4AhiIkDKbiTUos9qHOoYDeFhD8nniw8Q6Yq+Y1qTlUjmjodFMVo/kQoJpbFUlJ9iAMRr
         akVbwCgc1gkStXFdMRvPxWQqwlxWH2LguSs74=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Theodore Tso'" <tytso@mit.edu>
Cc: "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon, 6 Apr 2009 13:12:08 -0700
Message-ID: <002501c9b6f3$f85b4910$e911db30$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm28i4vKznRxY25QfS84ahpG8PmTgAAX+oQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grr..making writeback as default would break people's setup that relies on
the ordered semantics, especially in the embedded world. It's a big no-no.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Linus Torvalds
> Sent: Monday, April 06, 2009 12:57 PM
> To: Theodore Tso
> Cc: Jens Axboe; Linux Kernel Mailing List
> Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
> 
> 
> 
> On Mon, 6 Apr 2009, Theodore Tso wrote:
> >
> > Cool!  Maybe we can make things even better, but given where we are
> > at, this brings up an question: given Jens block latency patches
> > (thanks, Jens!), and the patches which add the flush on
> > replace-via-rename/replace-via-truncate for ext3 data=writeback,
> > should we make ext3 data=writeback the default for 2.6.30?
> 
> Yes. I want to go back and see how much this all helps for the
> data=ordered case (if at all), but I think we should at least consider
> trying 'data=writeback' as a default.
> 
> Does the 'synchronize on rename / close-after-ftrucate' patches leave
> any
> other intersting cases open?
> 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

