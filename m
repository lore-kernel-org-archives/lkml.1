Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXLMJ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXLMJ7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLMJ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:59:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48217 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbXLMJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:59:26 -0500
Subject: Re: [2.6 patch] videobuf-core.c locking fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Shane <gnome42@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Brandon Philips <brandon@ifup.org>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <fa4052ef0712121235x54e1837cs2efe4ce5c6e0e84d@mail.gmail.com>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
	 <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
	 <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
	 <20071212194454.GF10069@stusta.de>
	 <fa4052ef0712121235x54e1837cs2efe4ce5c6e0e84d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 07:59:13 -0200
Message-Id: <1197539953.4729.19.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > e1f8b4a49d86746f699919531c17fd154787e308
> > diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> > index 81f77d2..c8a5cb5 100644
> > --- a/drivers/media/video/videobuf-core.c
> > +++ b/drivers/media/video/videobuf-core.c
> > @@ -909,7 +909,7 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
> >         if (q->streaming)
> >                 goto done;
> >         if (!q->reading) {
> > -               retval = videobuf_read_start(q);
> > +               retval = __videobuf_read_start(q);
> >                 if (retval < 0)
> >                         goto done;
> >         }
> > @@ -982,7 +982,7 @@ unsigned int videobuf_poll_stream(struct file *file,
> >                                          struct videobuf_buffer, stream);
> >         } else {
> >                 if (!q->reading)
> > -                       videobuf_read_start(q);
> > +                       __videobuf_read_start(q);
> >                 if (!q->reading) {
> >                         rc = POLLERR;
> >                 } else if (NULL == q->read_buf) {
> >
> 
> Yes it does! I was just going to send the same patch myself :)

The patch seems ok to my eyes. I dunno why I forgot to replace those two occurrences on my patch :(

 
Cheers,
Mauro

