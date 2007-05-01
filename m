Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXEAKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXEAKDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031644AbXEAKDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:03:07 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:5609 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316AbXEAKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KYWLFuoWzKbVyGXRzXzSuK4uQgq+zBDU65G1slFDRU2evZ9X2Eh8ehMnQRcgR7VVof0UuqBIT2bde8DX3+TT0I/rwFkU5ps3sX04/leBvY0L0lFPb7irVw7hx7+lxaGjF8XKW/n18gIBKprYviwi4m9dtP/l9XEoHlzwJOTUDGM=
Message-ID: <4af2d03a0705010303v270e2b41jaf92058c87593070@mail.gmail.com>
Date: Tue, 1 May 2007 12:03:03 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: old buffer overflow in moxa driver
Cc: "=?UTF-8?Q?Ismail_D=C3=B6nmez?=" <ismail@pardus.org.tr>,
       "dann frazier" <dannf@hp.com>, linux-kernel@vger.kernel.org,
       support@moxa.com.tw, dilinger@debian.org
In-Reply-To: <20070501105214.078b4326@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430224829.GI31283@krebs.dannf>
	 <20070501000455.2173b1e2@the-village.bc.nu>
	 <200705010301.34571.ismail@pardus.org.tr>
	 <20070501105214.078b4326@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > At the point you abuse these calls you can already just load arbitary
> > > data from userspace anyway.
> >
> > So the possible exploit will only work when run by root, is that what you
> > mean? If so isn't that still a security problem?
>
> To exploit the hole you need CAP_SYS_RAWIO which is the highest
> capability of all. CAP_SYS_RAWIO gives you the ability to access hardware
> directly so since it checks for CAP_SYS_RAWIO it isn't security.

I understand that, but without it, the driver might seem buggy as far
as the person with permissions can write bad values and cause BUG().
On the other hand if the user has CAP_SYS_RAWIO, he has access to
/dev/{k,}mem anyway ;).

> The patch isn't wrong however and adds some sanity checking so it would
> do no harm to send it to Andrew for -mm testing.

Yes.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
