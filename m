Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXBEL4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXBEL4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXBEL4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:56:08 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:61500 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbXBEL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EuPO8STuTiMva4L7Ov//vbVmWyEn8FSDKyHOpZ9nzG/sfbtz46YTXTW7bh26f6CWPl51ssW2MzzimsjzMGogKBMxKi7wmwBJqtaku2/ewVYNVZqhdyNZ+IKEo0txtn1ULiOKYYacT1ahYxb69SpyKmzDcMUkznd9Vaea//4OnfI=
Message-ID: <45C71B51.9000304@gmail.com>
Date: Mon, 05 Feb 2007 20:56:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Eric D. Mudama" <edmudama@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Soeren Sonnenburg <kernel@nn7.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
References: <1168639639.3707.6.camel@localhost>	 <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com>	 <1169456682.2901.18.camel@localhost>	 <20070122210312.GD4516@khazad-dum.debian.net>	 <45B5A9C7.5050700@gmail.com>	 <20070123131040.GB13467@khazad-dum.debian.net>	 <45B6BF5D.1070300@gmail.com> <1169629789.3779.3.camel@localhost>	 <20070124153727.GC15402@khazad-dum.debian.net> <311601c90701251321s58c8c0e2s9050fbf9c41cabad@mail.gmail.com>
In-Reply-To: <311601c90701251321s58c8c0e2s9050fbf9c41cabad@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric D. Mudama wrote:
> In the ATA spec, the CHECK POWER MODE command (E5h) specifically
> states that it shouldn't alter the power mode of the device.
> Therefore, there should be no harm in checking the power mode of a
> device in STANDBY or IDLE state, and it shouldn't cause the device to
> spin up.  Checking a drive on my bench I confirmed this behavior.

Yes, we can but...

1. As I wrote in the other reply, I don't think that's necessary.
Devices don't spin up on FLUSH_CACHE followed by STANDBY_IMMEDIATE when
they are in Standby state. (Please point out if this isn't true on most
drives)

2. As the code currently stands, we have to rely on SCSI HLD for
shutting down.  We can query power state there and issue shutdown
conditionally and all those will be properly translated by libata but
it's a bit complex.  I'm not sure whether the added complexity is justified.

> With Serial ATA you have to consider the SATA bus PM states as well,
> but that's a different topic of discussion.

I think that can be dealt with separately.

Thanks.

-- 
tejun
