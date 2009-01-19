Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZASTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZASTNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZASTNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:13:01 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41168 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZASTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=NP7OeD9GONzJeEVNkmm+iwDwRY3xhxcPuuQ1NGcWmOs+5U4lpkcfpQGEAlujhq910I
         UGOpEfPM5SalNvT+w0zU3zlC0IjZzgv3DZQQYqcr2ntAtz1IQps3Bu3F2174nYAFVvjP
         ru/It6jXQIuSU5l85hLuXAFjcb4gDxAGTpw+Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
Date: Mon, 19 Jan 2009 20:12:51 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain> <4974CA81.1050506@ru.mvista.com> <20090119184951.35a52184@lxorguk.ukuu.org.uk>
In-Reply-To: <20090119184951.35a52184@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901192012.51422.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Alan Cox wrote:
> >     Tried looking at how in*()/out*() are defined on x86?
> 
> Tried looking at how ide_mm_inb is defined on x86
> 
> > > It's already making function calls, without the benefit of inlining and
> > 
> >     I'm afraid you're wrong here.
> 
> I'm afraid you are the one who is wrong. The IDE layer is duplicating a
> generic level of indirection with its own code - purely because IDE
> pre-dates that core functionality. The whole IDE layer indirection can go
> away because Linux has caught up with the needs of the IDE layer.

I wish it would be so simple as I would have removed the said indirection
long time ago.  Unfortunately:

- not all archs support ioread() & co.

- there is still issue with cache aliasing on some CPUs

Once above deficiences get fixed we can look into ioread() conversion again.

[ IOW right now it is the correct thing to stick to ide_mm_*() indirection
  since extra hardware coverage is more valuable than minor code cleanup. ]

Thanks,
Bart
