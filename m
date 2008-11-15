Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYKONoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYKONoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYKONo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:44:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:57554 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYKONoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eSXMO6v1xub199fYYejJkluGOwTPt3/VFN7onDXh5IucAm/o+NgP5mrWwJxndF5FQb
         9xs1FFk7ULN0zRixQQEJ8s0qwSaPSue+QRKiArlKoBjSqCmqUAKybBJFu7JFP9ipTVAo
         FLMNjMupPo0oGkaCNmCp3wXkDdvf8llYYTNsM=
Subject: Re: kernel BUG at fs/buffer.c:471! with 2.6.27.6
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com
In-Reply-To: <20081114175031.GA11737@infradead.org>
References: <gfjqlf$kpt$1@ger.gmane.org>
	 <20081114175031.GA11737@infradead.org>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 14:44:19 +0100
Message-Id: <1226756659.12440.7.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 12:50 -0500, Christoph Hellwig wrote:
> On Fri, Nov 14, 2008 at 12:24:19PM +0000, Alessandro Bono wrote:
> > Hi all
> > 
> > second time I hit this bug, first time with 2.6.26.6 (reported to xfs ml 
> > without response)
> > Condition are similar: rsync from remote server via ssh to a local usb hd 
> > with a xfs filesystem but connection this time is with a wired ethernet 
> > not wifi
> > Tell me if you need other info
> > 
> > kernel BUG at fs/buffer.c:471!
> 
> In 2.6.27.6 line 471 in fs/buffer.c is inside write and looks like this:
> 
> 	first = page_buffers(page)
> 
> and page_buffers is defined as:
> 
> #define page_buffers(page)                              \
> ({                                                      \
> 	BUG_ON(!PagePrivate(page));			\
> 	((struct buffer_head *)page_private(page));     \
> })
> 
> So we get a page without page_private set.
> 
> Now XFS always creates buffers in writepage when it doesn't have those
> yet using the VFS helper create_empty_buffers which calls
> attach_page_buffers, which sets the page private flag.
> 
> 
> Given that the binary 3d driver always caused random VM problems can you
> try to reproduce it with one loaded?

Hi Christoph

I switched from fglrx to radeon and I'll try to reproduce this bug (I
didn't know my card is supported form normal radeon driver), but it's
not easy to hit. I'll report back if I can recreate the same condition

Thanks for your response

---

Cordiali Saluti
Alessandro Bono

