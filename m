Return-Path: <linux-kernel-owner+w=401wt.eu-S1766704AbXDSOEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766704AbXDSOEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766708AbXDSOEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:04:47 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:44340 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766704AbXDSOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AqKYusEMMl99eEkiNW6OTg7zyMFmD32E6ORG6Orc+GTBKfAMwDAu0SQDYX7tjYFI4iZhz0AGjvynROpAPnjw0i/EVM2n5ibtdCpYfGPCtRk1607P15RMveAcSReX9F+VTB/ZhKzhUCsx/G7WsMM6ygn1pxi1SggVUqvBmvl9u1I=
Message-ID: <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>
Date: Thu, 19 Apr 2007 19:34:46 +0530
From: "Madhusudhan c" <cr.madhusudhan@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: MMCv4 support (8-bit support missing)
Cc: linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <46262953.3040801@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
	 <4625DAFC.4000208@drzeus.cx>
	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
	 <46262953.3040801@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Perre,

>I don't think I've seen that patch. And now we have the work by Philip and
> myself which adds support for both MMC 4.0 and 4.2. The only missing piece is
> 8-bit data and I'm not that interested in adding it until we have a driver that
> can use it.
Here is a link to that patch.

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=3489/1

The bus test procedure from this patch can be adopted to the MMCv4
support in the MMC core with small changes to do bus testing procedure
only if the host sets the capability to support 8-bit. That way we
dont break the legacy code. What do you think?

On 4/18/07, Pierre Ossman <drzeus@drzeus.cx> wrote:
> Madhusudhan c wrote:
> >
> > Kyung-ju Hyun from samsung had submitted a patch for MMCPlus support
> > long back, which had the bus testing procedure implemented and it
> > works fine. I am able to write and read the data pattern back
> > successfuly with his patch. I am not sure why his patch was not
> > integrated into the main line kernel.
> >
>
> I don't think I've seen that patch. And now we have the work by Philip and
> myself which adds support for both MMC 4.0 and 4.2. The only missing piece is
> 8-bit data and I'm not that interested in adding it until we have a driver that
> can use it.
>
> > Why should we be bothered about how controllers respond at the MMC
> > core level. We need to just implement what specification says and
> > leave the controller handling part to the controller driver. Am I
> > correct?
>
> Kindof. The controller drivers should indeed just handle the controller and
> leave the protocol stuff to the mmc core. The problem is that this bus testing
> stuff breaks the previous standards. Sending invalid CRC was not previously a
> supported operation, so many controllers just toss the data when that happens.
> And since the bus testing is specified as a test, not a required part of the
> wide bus song and dance, we've decided to leave it out.
>
> Rgds
> Pierre
>
>
>
>
