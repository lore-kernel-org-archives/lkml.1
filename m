Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXBSQLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXBSQLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXBSQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:11:07 -0500
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:61187 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932388AbXBSQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:11:06 -0500
Date: Mon, 19 Feb 2007 17:08:18 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       James.Bottomley@steeleye.com, dougg@torque.net
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <45d9cb72.je+WdtrFM7WV89m8%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0702191051210.13197-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702191051210.13197-100000@netrider.rowland.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
