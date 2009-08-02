Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZHBNkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZHBNkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZHBNkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:40:01 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60447 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZHBNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=e2fJFj9J/ptPj5m9ehGrYa5wsP2XdmzSdBro+H/idZ2Waf7pbPwu4vhKQ14fdwsKx8
         XcAywgj/zhasHb4+DqKtTy7/hbd4bXZH36AkkV9JY0bYYoIIRY0VqdvDr0FnFSzDkZam
         bpsvPZXarsAL0tWG0gT/2aPjHZHQE1/Xm80sE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jack Byer <ojbyer@usa.net>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
Date: Sun, 2 Aug 2009 15:38:45 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <h51hro$p6j$1@ger.gmane.org>
In-Reply-To: <h51hro$p6j$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908021538.45180.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 August 2009 16:02:22 Jack Byer wrote:
> I have an old digital camera that stores its pictures on a 340 MB IBM 
> microdrive. I am trying to transfer to pictures from the camera to my 
> computer but can not find the special non-standard USB cable. The 
> camera did come with a CompactFlash to PCMCIA adapter, so tried 
> connecting it to my laptop. I was able to install the correct modules 
> and mount the drive, but accessing it is very slow (5.0 kBps read / 
> 3.8 kBps write). Is this expected behavior? Is there any setup I am 
> missing that would make this faster?

Get 2.6.31-rc5 kernel.

Set:

	CONFIG_IDE=m
	CONFIG_BLK_DEV_IDECS=m

in the kernel config.

Build, install, reboot.

Load ide-cs module.

Enjoy the speed increase using /dev/hda.

You may try "hdparm -c1 /dev/hda" for an extra enjoyment.
