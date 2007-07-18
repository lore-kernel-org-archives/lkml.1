Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbXGRRU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbXGRRU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXGRRUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:20:49 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:44574 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932546AbXGRRUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:20:48 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=bdc4ZpIJ/4yvWtUvKLT4yt7gfFmCcDQ6R8fOW2oe+/GO9W3tYANs5CIHLbBd2moz17KWkIYYPut6WXFRJr5vrw==  ;
From: TAKADA Yoshihito <takada@mbf.nifty.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: i386: pata_cs5520 does not work
Cc: linux-kernel@vger.kernel.org, teheo@novell.com
In-Reply-To: <20070718144212.3289e86c@the-village.bc.nu>
References: <20070716.091928.111205836.takada@mbf.nifty.com> <20070718144212.3289e86c@the-village.bc.nu>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.064
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.28.01 [ja]
Message-ID: <20070718172045.24362.qmail@smb518.nifty.com>
Date: Thu, 19 Jul 2007 02:20:45 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Thanks for reply.
It is not issue of pata_cs5520.
In good case, ReiserFS detects root partition.
Bad case, ReiserFS does not detects partition.

ReiserFS: sda2: found reiserfs format "3.6" with standard journal

On Wed, 18 Jul 2007 14:42:12 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > I'll take a look at this next week. Can you send me a dmesg of the
> > > working case and an lspci -vvxxx
> > 
> > Thanks. attached 2 dmesgs(2.6.21 with pata_cs5520, 2.6.22 with IDE) and output of lspci.
> 
> Nothing obviously wrong. What happens if you find the line
> 
> if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
> 		return -ENOMEM;
> 
> in pata_cs5520.c and change the end from return -ENOMEM to 
> 
> if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
> 		panic("IO MAP");
> 
> This should help identify where the problem occurs

-- 
TAKADA <takada@mbf.nifty.com>

