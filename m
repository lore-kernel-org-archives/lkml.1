Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbXFASYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbXFASYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761283AbXFASYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:24:39 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:39594 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760990AbXFASYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:24:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2/3] 2.6.22-rc3: known regressions v2
Date: Fri, 1 Jun 2007 14:24:33 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55540@otce2k301.adaptec.com>
In-reply-to: <20070601175344.GA13721@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2/3] 2.6.22-rc3: known regressions v2
Thread-Index: AcekeIzFZU35TdvoQ2ikFp3c4+7hXAAACZiQ
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: <vgoyal@in.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       <linux-pcmcia@lists.infradead.org>,
       "Robert de Rooy" <robert.de.rooy@gmail.com>,
       "Alan Cox" <alan@redhat.com>, "Tejun Heo" <htejun@gmail.com>,
       <linux-ide@vger.kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Gregor Jasny" <gjasny@googlemail.com>, <linux-scsi@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@SteelEye.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, <sparclinux@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Agree, but overstated somewhat.

The card in question that the regression is reported against is not a
released card and as such could have a flawed environment, Hardware,
Firmware or other Incompatibility. The fix for the root cause will
likely not touch the driver or the kernel.

It does raise the specter of a possible follow-on patch to address the
root cause under kdump should we determine that the problem can not be
solved in time of release of the Firmware of the current pre-released
card or if we discover that other released cards have a similar Firmware
or Hardware bug. Speculation such as these do not belong on kernel
regression reports IMHO.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com] 
> Sent: Friday, June 01, 2007 1:54 PM
> To: Andrew Morton
> Cc: Michal Piotrowski; Linus Torvalds; LKML; 
> linux-pcmcia@lists.infradead.org; Robert de Rooy; Alan Cox; 
> Tejun Heo; linux-ide@vger.kernel.org; Jeff Garzik; Gregor 
> Jasny; linux-scsi@vger.kernel.org; James Bottomley; AACRAID; 
> Yinghai Lu; Vivek Goyal; sparclinux@vger.kernel.org; David 
> Miller; Mikael Pettersson
> Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
> 
> 
> On Fri, Jun 01, 2007 at 09:01:15AM -0700, Andrew Morton wrote:
> > On Fri, 01 Jun 2007 14:20:55 +0200 Michal Piotrowski 
> <michal.k.k.piotrowski@gmail.com> wrote:
> > 
> > > SCSI
> > > 
> > > Subject    : aacraid: adapter kernel panic'd fffffffd (kexec)
> > > References : http://lkml.org/lkml/2007/5/29/491
> > > Submitter  : Yinghai Lu <yhlu.kernel@gmail.com>
> > > Handled-By : Salyzyn, Mark <mark_salyzyn@adaptec.com>
> > >              Vivek Goyal <vgoyal@in.ibm.com>
> > > Status     : problem is being debugged
> > 
> > Mark's 
> aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is
> > known to fix this, so we can move this to "known 
> regressions with patches"
> 
> Hi Andrew,
> 
> aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is meant
> to ensure that we don't perform an unnecessary reset of the device
> during a kexec boot. During kexec, we perform the device_shutdown()
> which should bring the device to a known sane state and a reset is
> not required while next kernel is coming up.
> 
> I think this fix just masks Yinghai's problem and as such does not
> fix the root cause of the problem. In his case a software reset
> of the card is not successful and this is a problem. This problem
> will become visible during kdump.
> 
> So I would think that this regression is still there just that got
> shifted from kexec to kdump.
> 
> But we do need above patch to make sure kexec boot is fast and does
> not perform any unrequired device reset.
> 
> Thanks
> Vivek
> 
> 
> 
