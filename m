Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbXBOGaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbXBOGaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXBOGaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:30:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:39447 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXBOGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OTE3MJ2LoNz0sIIQWV5yVlcIN/a64LbkCYTZ+GmNqrsj6pnkpSwmtPkheE+m9SwVSovoc0KfIxUA1hn8+0U7aIp3cpTw51NvBX/XsGhOxgjWbrY7vAkocoDJHAoZ55Zocl3wCAc1WUfB1DMzCCQS2k+gDzU+7Ox9FqOxA0h+3Bg=
Message-ID: <5767b9100702142230k57520a0la9227b73e5742643@mail.gmail.com>
Date: Thu, 15 Feb 2007 14:30:02 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Tejun Heo" <htejun@gmail.com>
Subject: Re: [LIBATA BUG] sr.c: TEST_UNIT_READY error
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <5767b9100702122330m21ecdb1dp69fc3a6a720b2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
	 <20070129144055.151cfe52@freekitty> <45C9C8BF.6030501@garzik.org>
	 <1170395286.4626.11.camel@localhost.localdomain>
	 <5767b9100702122330m21ecdb1dp69fc3a6a720b2a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Conke Hu <conke.hu@gmail.com> wrote:
> On 2/2/07, Conke Hu <conke.hu@amd.com> wrote:
> > On Wed, 2007-02-07 at 07:40 -0500, Jeff Garzik wrote:
> > > Conke Hu wrote:
> > > > Hi,
> > > >    TEST_UNIT_READY in get_capabilities (drivers/scsi/sr.c line 743, or
> > > > see below) always returns error.
> > > >
> > > >   ---------------- code begin -----------------------------
> > > >     retries = 0;
> > > >     do {
> > > >         memset((void *)cmd, 0, MAX_COMMAND_SIZE);
> > > >         cmd[0] = TEST_UNIT_READY;
> > > >
> > > >         the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
> > > >                            0, &sshdr, SR_TIMEOUT,
> > > >                            MAX_RETRIES);
> > > >
> > > >         retries++;
> > > >     } while (retries < 5 &&
> > > >          (!scsi_status_is_good(the_result) ||
> > > >           (scsi_sense_valid(&sshdr) &&
> > > >            sshdr.sense_key == UNIT_ATTENTION)));
> > > >   ---------------- code end -----------------------------
> > > >
> > > >   I debugged all kernel versions from 2.6.17 to 2.6.20 on several AMD
> > > > and other vendor's PATA/IDE controllers, and I get the_result==0x8000002
> > > > and retries==5; on silicon image 3132, i get the_result=0x2eb.
> > > >   Does 0x8000002 mean ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION)?
> > > > what's wrong?
> > >
> > > What does the sense data returned in the sense buffer say is wrong?
> > >
> > >       Jeff
> >
> > I dump scsi_sense_hdr as follows:
> > sshdr.response_code = 0x70
> > sshdr.sense_key = 0x2
> > sshdr.asc = 0x3a
> > sshdr.ascq = 0x1
> > sshdr.additional_length = 0x0
> >
> > the sense_key is 0x2 (NOT_READY), but the expected UNIT_ATTENTION :(
> but "NOT" the expected UNIT_ATTENTION.
>
> >
> > BTW, I am sorry for a mistake, Sil3132 also returns 0x8000002, not 0x2eb
> > as I said in the first mail. In a word, all cases return "the_result" as
> > 0x8000002.
> >
>
>
> the bytes 0 ~ 13 in sense buffer are:
> 70 00 02 00 00 00 00 0a 00 00 00 00 3a
> other bytes are all 0x00;
>
> in fact this issue can be reproduced in any libata driver, either sata or pata.
>
> Conke
>

[resend]
any suggestion ?
