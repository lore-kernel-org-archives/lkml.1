Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXEPNZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXEPNZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXEPNYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:24:55 -0400
Received: from lazybastard.de ([212.112.238.170]:58222 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXEPNYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:24:54 -0400
Date: Wed, 16 May 2007 15:20:35 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516132035.GJ5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI> <20070516122603.GE5472@lazybastard.org> <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 15:36:44 +0300, Pekka Enberg wrote:
> On 5/16/07, Jörn Engel <joern@lazybastard.org> wrote:
> >
> >More trouble?
> 
> Forgot to add (see below). Seems logfs_segment_read would be simpler
> too if you fixed this.

Would it?  I think that code would still be needed, although possibly in
a different function.

There are two minor drawbacks to using the page cache, btw:
- Indirect blocks need some mapping too.  So either I need to steal a
  bit from the inode space or from the fpos space.
- OOM handling is a bit more complicated.  I would need a mempool for
  that.

> >[ Objects are the units that get compressed.  Segments can contain both
> >compressed and uncompressed objects. ]
> >
> >It is a trade-off.  Each object has a 24 Byte header plus X Bytes of
> >data.  Whether the data is compressed or not is indicated in the header.
> 
> Was my point really. Why do segments contain both compressed and
> uncompressed objects?

Compressing random data will actually enlarge it.  If that happens I
simply store the verbatim uncompressed data instead and mark it as such.

There is also demand for a user-controlled bit in the inode to disable
compression completely.  All those .jpg, .mpg, .mp3, etc. just waste
time by trying and failing to compress them.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
