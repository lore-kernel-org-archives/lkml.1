Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYLBBnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYLBBnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYLBBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:43:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYLBBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=g/Vfe1U932GaYY4SXpt2Ukz+7TJfApWrsJrUiRDsJFAqHXawgP+4Sr+hJg/bg/UqHi
         THVUdnF/rqCkuph5kXXujHauFQrU7MyfARDWsyMIuA1pyqrAuUYIyUJGWnQVRg25ioU8
         i9qa7YmhYRaYOgIUhRUr/EwGaXONvguqdsorA=
Message-ID: <30353c3d0812011743we0bdddk2c9c37dd0191cf2a@mail.gmail.com>
Date: Mon, 1 Dec 2008 20:43:38 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: Promise PDC20376
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <18732.3809.720247.329641@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0810240704n7476cc50y28b3eb8a5f326626@mail.gmail.com>
	 <30353c3d0811250616o733fb7f9ob4af96dd604f78ea@mail.gmail.com>
	 <18732.3809.720247.329641@harpo.it.uu.se>
X-Google-Sender-Auth: 33fa4f3bb6790ba0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Since I put this out there, I felt it was important to follow-up on so
>  > others could benefit from my experiences. After extensive testing, the
>  > cause of the problems I've experienced are a result of a bug in the
>  > Fasttrak bios for the Promise 376 controller. Specifically speaking,
>  > bios interrupt 13h, AH=42 fails to read the requested sector from the
>  > drive despite the fact that bios interrupt 13h, AH=41, BX=0x55AA
>  > indicates the drive supports LBA extensions. The only known
>  > work-around at this time is to limit the size of the primary boot
>  > partition to 8GB or less and place it below the 8GB boundary where LBA
>  > extensions are not required to read the drive. I have contacted
>  > Promise concerning this issue and will provide more updates if
>  > anything metabolizes. Until then any users experiencing similar issues
>  > should use the work-around I've described above to boot the operating
>  > system of their choice.
>
> For booting with grub only /boot needs to be accessible by the BIOS,
> so it's common to make /boot a separate partition early on the disk
> with / and other partitions higher up.
>
> This is the first I've heard of any Promise SATA controller having
> such lame limitations.
>

A small update to this. It seems the above mentioned interrupt fails
somewhere around the 128GB boundary. Interrupt 13h, AH=42 uses a 64
bit sector address and should be capable of addressing the entire
drive. For a SATA controller, this limitation seems relatively
arbitrary. For IDE controllers, a limitation such as this is
apparently common.

Regards,

David Ellingsworth
