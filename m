Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXDBIhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXDBIhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXDBIhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:37:41 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:36736 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbXDBIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:37:40 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 04:37:39 EDT
From: Joerg Schilling <schilling@fokus.fraunhofer.de>
Message-Id: <200704020828.l328SICc009264@burner.fokus.fraunhofer.de>
Date: Mon, 02 Apr 2007 10:28:18 +0200
To: stern@rowland.harvard.edu
Cc: dougg@torque.net, James.Bottomley@steeleye.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls Re:
 [PATCH] Block layer: separate out queue-oriented ioctls
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a repost as I like to know the current state of the problem...

The USB DMA size problem is known to exist on Linux since February 2004.
I am still in hope that there will be a fix soon.

/*--------------------------------------------------------------------------*/
Alan Stern <stern@rowland.harvard.edu> wrote:

> Well, if Doug wants to reduce the value returned by SG_GET_RESERVED_SIZE, 
> it's okay with me.  An advantage of doing this is that older versions of 
> cdrecord would then work correctly.
>
> However you don't seem to realize that people can use programs like
> cdrecord with devices whose drivers don't support SG_GET_RESERVED_SIZE --
> because that ioctl works only with sg.  Programs would have to try
> SG_GET_RESERVED_SIZE and if it faied, then try BLKSECTGET.

Is there any reason not to have one single ioctl for one basic feature?

> Remember also, the "reserved size" is _not_ the maximum allowed size of a
> DMA transfer.  Rather, it is the size of an internal buffer maintained by
> sg.  It's legal to do an I/O transfer larger than the "reserved size", but 
> it is not legal to do an I/O transfer larger than max_sectors.

At the time the call SG_GET_RESERVED_SIZE has been discussed/defined, we did 
originally agree that the max value should be limited to what the HW allows
as DMA size. This is why I did originally files a bug against 
SG_GET_RESERVED_SIZE.
/*--------------------------------------------------------------------------*/

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
