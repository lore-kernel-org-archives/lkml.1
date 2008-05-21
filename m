Return-Path: <linux-kernel-owner+w=401wt.eu-S934579AbYEUNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbYEUNOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYEUNOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:14:05 -0400
Received: from smtp01.msg.oleane.net ([62.161.4.1]:37774 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYEUNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:14:04 -0400
From: Thomas Nemeth <thomas.nemeth@betatech.fr>
Organization: BETAtech
To: linux-kernel@vger.kernel.org
Subject: PCI driver architecture [repost]
Date: Wed, 21 May 2008 15:14:11 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2111195.LnjuZB7qIq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805211514.11584.thomas.nemeth@betatech.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2111195.LnjuZB7qIq
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[sorry - bad previous post]

    Hi!

    I was going to ask a few questions to Greg KH when he told me that
    my questions "look very reasonable for there, as long as I also
    post my code".

    So here is the context: we are developping 2 multi-IO boards at the
    request of our customer and, unfortunately, they asked us to
    develop their driver for Linux 2.4. As they are evaluating the
    possibility to switch to 2.6 in some months I'm writing the driver
    with 2.6 in mind.
    I have already made some basic char drivers for our custom ARM
    systems (GPIO/ADC/FPGA) and even begun a custom ARM-based
    architecture support. I have read, of course, a lot of documentation
    before: LDD2, LDD3 (of course), CodingStyle, How to NOT write a
    device driver, writing portable device drivers, Device Drivers DOs
    and DON'Ts and some other books, web sites and PDF about embedded
    linux.

    These boards will present the user a bunch of IO lines a bit like
    GPIO. Registers are to be mapped into memory. By now the design is
    not complete and we still are discussing if registers will present
    information for all lines (eg: a data register for all lines, an
    interrupt register holding information for all lines...) or 1
    register per line holding the all information related to that line
    (data, interrupt type, interrupt occured...). Anyway, that's not
    really important right now.

    I have already written some code for this driver. As I saw, in the
    FAQ, that I might be well advised to put my code on a website/ftp,
    here it is: http://tnemeth.free.fr/projets/btmio.c


    My questions are the following ones:

    - I use a probe() function that calls request_region() in order to
      have access to the boards' registers. I have called ioremap() on
      the requested region. Is that the right thing to do?

    - I think I should make a "char" driver to allow access to device
      nodes and this driver is registered at loading time. Is that
      right too?
      For now I coded the following things:
      - driver_init calls pci_register_driver and register_chrdev
      - device_probe sets up the detected boards
      - when a program opens a device node, if the board has not been
        configured by the probe function, it returns an error.

    - I have to use IOCTLs to manage configuration of (eg) interrupts
      (set/get[/reset] interrupt type, read/write to only 1 line). As it
      is something frowned upon, where could I get some IOCTLs to reuse?


    As I haven't subscribed to the list could I be CC'd for the reply ?
    Thanks in advance.

Thomas
=2D-=20
Thomas Nemeth - Ing=E9nieur d'=C9tudes en Informatique Industrielle
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Industrial Computing Software Designer
BETAtech - 15, rue Apollo, Z.A. de Montredon, 31240, L'Union.
05 34 30 40 00 (standard) =A0/ =A005 34 30 40 09 (ligne directe)

--nextPart2111195.LnjuZB7qIq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBINCAjHPRSmTSubacRAhADAJ9IhR3hcocoX6eQ8gNDnwNwDlw3OACgkW3L
zTJr243POtQ4cJJvoXwXoR0=
=Ul5V
-----END PGP SIGNATURE-----

--nextPart2111195.LnjuZB7qIq--
