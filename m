Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYGMMeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYGMMeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 08:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYGMMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 08:33:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:28792 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYGMMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 08:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZYGDrEwNiBQ/xh65Hz+dpxVHkuM6kXJMOeNkGaG3B3gc2bkEeO2+7NQcptP+f9+Kdi
         ffh92Lh25hJ+HYyW3e1v7SoSTG7nfnka43n0HzFfAkZo+CjEqtdiE7nV3+HkcT+nRaaC
         B4FOWc90V+b8TF+2HiVUb7BD1JwhT4KPnoei4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
Date: Sun, 13 Jul 2008 14:34:16 +0200
User-Agent: KMail/1.8.2
Cc: T?r?k Edwin <edwintorok@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <20080710215039.2A143154218@magilla.localdomain> <200807122257.59047.vda.linux@googlemail.com> <20080713104617.GA79@tv-sign.ru>
In-Reply-To: <20080713104617.GA79@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131434.16654.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 July 2008 12:46, Oleg Nesterov wrote:
> On 07/12, Denys Vlasenko wrote:
> >
> > On Saturday 12 July 2008 22:26, T?r?k Edwin wrote:
> > > A bit off-topic, but something I noticed during the tests:
> > > In my original test I have rm-ed the files right after launching dd in
> > > the background, yet it still continued to write to the disk.
> > > I can understand that if the file is opened O_RDWR, you might seek back
> > > and read what you wrote, so Linux needs to actually do the write,
> > > but why does it insist on writing to the disk, on a file opened with
> > > O_WRONLY, after the file itself got unlinked?
> >
> > Because process can do
> >
> > fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_RDWR)
> 
> Is it?
> 
> SETFL_MASK doesn't have O_RDWR, and in any case setfl() changes ->f_flags,
> not ->f_mode.

Just tested it and you are right.

I distinctly remember seeing such code somewhere. Interesting.
Now I wonder whether it was a bug, or those were not file descriptors,
but sockets?...
--
vda
