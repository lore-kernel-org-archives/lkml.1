Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYIMImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYIMImm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYIMImc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:42:32 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:60224 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYIMImb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:42:31 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Sat, 13 Sep 2008 10:41:33 +0200
User-Agent: KMail/1.9.5
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809121224.34345.jwilson@redhat.com> <200809130226.35998.j@jannau.net>
In-Reply-To: <200809130226.35998.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131041.33717.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: a37c3661e0372786d6c154dc38711565
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 September 2008 02:26, Janne Grunau wrote:
> On Friday 12 September 2008 18:24:33 Jarod Wilson wrote:
> > > I just want to thank you very much for your work and give you my
> > > Tested-By. Todays git (b2e9c18a32423310a309f94ea5a659c4bb264378)
> > > works well here with lirc-0.8.3 userspace on a Pentium
> > > 3/i815-system.
> >
> > Oh good! I haven't broken anything further w/my changes up to
> > b2e9c18... ;) I've got another slew of updates to lirc_serial still
> > pending though
>
> I hope I haven't broken anything with my lirc_dev changes. I doubt I'll
> have a change to test it before monday.

Unfortunately, you did. Commit ea74897 (port lirc to dynamic device numbers) 
broke things.
This is what ea74897 and further (latest tested was dd13cc7) are telling me:

$ insmod drivers/input/lirc/lirc_dev.ko
$ insmod drivers/input/lirc/lirc_serial.ko
insmod: error inserting 'drivers/input/lirc/lirc_serial.ko': -1 Input/output 
error
$ dmesg | tail
lirc_dev: IR Remote Control driver registered, major 253 
lirc_serial: auto-detected active low receiver
lirc_dev: lirc_register_driver: sample_rate: 0
lirc_serial: register_chrdev failed!


There has also been a compile issue in the meanwhile, introduced with 95efa30 
(inb/outb and readb/writeb deal in u8 types), but this is gone with todays 
git pull :)


I'll keep on testing (unfortunately only at weekends),
regards, Stefan
