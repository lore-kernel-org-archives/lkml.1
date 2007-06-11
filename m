Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXFKTpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXFKTpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXFKTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:45:36 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:40697 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbXFKTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:45:35 -0400
X-Greylist: delayed 1064 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 15:45:34 EDT
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Date: Mon, 11 Jun 2007 21:27:41 +0200
User-Agent: KMail/1.9.4
References: <20070611101319.GA14284@DervishD> <Pine.LNX.4.64.0706110754280.12140@blackbox.fnordora.org> <20070611174223.GB2433@DervishD>
In-Reply-To: <20070611174223.GB2433@DervishD>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706112127.42119.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007 19:42, DervishD wrote:
>     I just was curious about the issue and I was asking to know if
> anybody had tried this.

Think about compact flash devices. They also using some kind of flash memory 
and also doing wear leveling. And I think they are not only used with 
FAT16/32! If they run with different filesystems, then your pendrive stick 
will also. Only the interface is different.

> I know about cheap pendrives that you cannot format even with FAT32, only
> with FAT16.

I'm not sure if the price was the reason that they failed with different 
filesystems. Some kind of wear leveling tries to guess which blocks of the 
filesystem are in use and which are unused (to avoid wear leveling of unused 
data).
But it only works if you are using a filesystem that is "known" by the wear 
leveling process. If you are using a different one, it fails badly, because 
it tries to interpret a FAT that does not exists, and destroys your 
filesystem while the wear leveling process is running. So this cheap pendrive 
was too intelligent for filesystems other than FAT16....

So if you can use a different filesystem than FAT16/32 on your pendrive, it 
does not matter what kind of filesystem you are using. The wear leveling 
process has no clue about it and always "wear leveling" used *and* unused 
data (means: every block of the whole disk) until it ruins the flash memory.

Hope it helps
Juergen
