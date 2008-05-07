Return-Path: <linux-kernel-owner+w=401wt.eu-S1764481AbYEGHN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764481AbYEGHN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbYEGHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:13:05 -0400
Received: from mail.syneticon.net ([213.239.212.131]:37149 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYEGHNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:13:01 -0400
Message-ID: <48215673.3060201@wpkg.org>
Date: Wed, 07 May 2008 09:12:51 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: Compact Flash Question
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:

> For most Linux filesystems you really need wear leveling. E.g. ext3's
> superblock is at a fixed location and gets overwritten frequently.
> Without wear leveling you risk that the flash sector where the
> superblock resides wears out early.

Compact Flash (and other similar media) does wear levelling, so essentially, 
even if we write to the same fixed location, in reality, it will mostly go to a 
different area on flash each time.

As Compact Flash and its wear levelling does not know about free space on the 
filesystem, the wear levelling's effectiveness can be only limited - writes 
won't spread on the whole free area of the flash.

Does anyone know how wear levelling is done in these devices? Perhaps it will 
differ from a manufacturer to manufacturer, but I guess they have a free area we 
normally use to store data, and some reserved area used just for wear levelling 
and bad block handling, but that's just my guess.


> When using ext3 on a CompactFlash, you can limit the number of writes
> to the CompactFlash significantly by mounting the medium with
> parameters like noatime,nodiratime,commit=300.

noatime implies nodiratime, so there is no need to add the latter.


-- 
Tomasz Chmielewski
http://wpkg.org

