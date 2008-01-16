Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYAPUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYAPUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAPUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:33:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYAPUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:33:44 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional ttyS names
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Reply-To: 7eggert@gmx.de
Date: Wed, 16 Jan 2008 21:33:04 +0100
References: <9MjWa-VI-9@gated-at.bofh.it> <9MjWb-VI-11@gated-at.bofh.it> <9MlEG-3Mx-13@gated-at.bofh.it> <9Mmra-56f-29@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JFEwb-0000zs-2q@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+W8Li6vqYRMrTnmuLEtCc1delLuIBFZzjWeS8
 AjF60IAkg+DNETLHeugpn0xMRnsVs4emtxK5DVecJ4OhN0gyK9
 +cvySMmOidul6RE1MpPYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 16 January 2008 11:44:37 am H. Peter Anvin wrote:
>> Bjorn Helgaas wrote:

>> > +#ifdef CONFIG_X86
>> > +  switch (port->iobase) {
>> > +  case 0x3f8:     return 0;       /* COM1 -> ttyS0 */
>> > +  case 0x2f8:     return 1;       /* COM2 -> ttyS1 */
>> > +  case 0x3e8:     return 2;       /* COM3 -> ttyS2 */
>> > +  case 0x2e8:     return 3;       /* COM4 -> ttyS3 */
>> > +  }
>> > +#endif
>> > +
>> 
>> Arguably, the right thing is to use the addresses present in the array
>> at address 0x400.  In particular, COM3 and COM4 aren't always at those
>> addresses.
> 
> Wow.  I bow before your storehouse of x86 arcana :-)
> 
> I guess you're referring to the "BIOS data area," which I'd never
> heard of before (but fortunately, Google knows).

You'll want to google for Ralph Brown ...
if your back allowes bowing that much.

> What would you think about doing this only for COM1 and COM2?  The
> only real value for doing this in the first place is so "console=ttyS0"
> always goes to COM1, even if we don't have SERIAL_PORT_DFNS.  User-
> space ought to use some sort of udev magic if it cares about persistent
> naming.

Since the first four COM ports are magic, and since using the BIOS port
numbers will move the non-legacy ports anyway, you should use all up to
four stored port numbers.

BTW1: These addresses may be used to detect ports on non-standard addresses,
but unfortunately they don't tell the IRQ.

BTW2: When I submitted a patch using the BIOS data area, I was told that it
might not exist on systems booting from non-PC firmware. This claim was not
yet backed with any knowledge, nor did anybody suggest a way to detect this
situation.

