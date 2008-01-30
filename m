Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYA3Cn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYA3Cn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYA3Cnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:43:49 -0500
Received: from [211.102.241.196] ([211.102.241.196]:33688 "EHLO mail.yuvad.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYA3Cns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:43:48 -0500
From: "Mao Rui" <maorui@yuvad.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: SATA DOM is not identified by ata_piix module
Date: Wed, 30 Jan 2008 10:42:12 +0800
Message-ID: <071501c862e9$c0bf1770$7740a8c0@cmaorui2>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <00da01c85999$0856e540$7740a8c0@cmaorui2>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchXZ9P+lznWGrtKQ+WaInNR7zRNBwBjvoRQAnyzKtA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... Does anybody own this bug?

Best regards,

Mao Rui


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Mao Rui
> Sent: Friday, January 18, 2008 2:12 PM
> To: 'Alan Cox'
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: SATA DOM is not identified by ata_piix module
> 
> I tried to nail down when the problem was introduced. I compiled some
> official kernel release. Here is the result.
> 2.6.17.14   IDE -- Failed   SATA -- passed
> 2.6.18   IDE -- Failed   SATA -- failed
> 2.6.18.8   IDE -- Failed   SATA -- failed
> 2.6.24-rc7-git6  IDE -- passed   SATA DOM -- failed
> linux-2.6.24-rc8-git1   IDE -- passed    SATA -- failed
> All IDE failed reason is xfermode error, and all SATA failure is IDENTIFY
> error.
> 
> As you can find out, the failure of SATA DOM was introduced from kernel
> 2.6.18.
> 
> I'm not good at low level driver programming, so I cannot find out the
root
> cause by myself. But if Alan or someone else needs more info or wants to
> test the patch, I'm glad to do it in my platform.
> 
> Best regards,
> Mao Rui
> 
> > -----Original Message-----
> > From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> > Sent: Tuesday, January 15, 2008 7:02 PM
> > To: Mao Rui
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: SATA DOM is not identified by ata_piix module
> >
> > On Tue, 15 Jan 2008 18:11:25 +0800
> > "Mao Rui" <maorui@yuvad.com> wrote:
> >
> > > Hi,
> > >
> > > I have a PQI Turbo SATA DOM. It works well under Windows. I installed
it
> in
> > > a SuperMicro motherboard, Intel 5000P chipset. The OS is Ubuntu 7.04,
> kernel
> > > 2.6.20-15. But the DOM is not appeared as a device node, and I found
> several
> > > error messages in kernel log.
> >
> > Generally it is a good idea to report problems with vendor built kernels
> > to the vendor and their support, especially one that is 3 releases
behind.
> > They have a much better idea what is in that kernel and who else has
seen
> > problems.
> >
> > > [   67.124299] ata2.00: qc timeout (cmd 0x91)
> > > [   67.124306] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> > > err_mask=0x4)
> >
> > We issued commands, it didn't respond. That could be a libata problem
but
> > actually looks more like an IRQ routing problem.
> >
> > > Actually I also have a PQI IDE DOM, it have same error with Ubuntu
7.04
> /
> >
> > The PQI DOM is a bit odd, it is however known to work with libata at
> > least for the PATA one, and the versions which don't understand
> > SET_XFER_MODE to work with current kernels. (Your failure mode isn't the
> > SET_XFER_MODE one - it hasn't got that far).
> >
> > Alan
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


