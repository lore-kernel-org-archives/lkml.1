Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYG2XA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYG2XA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYG2XAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:00:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:9118 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYG2XAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jYVSqbxR1XRCyJ98wm68pKRwN495/VpeCOVOU+FmYm35a8riVLO3FGCpGVbgKq/az/
         AGbuinTuCMIhdkcmfZ2hAIt4LHXMsIBZe57QiNshHu23q0gRLk4nl1cmHGJRk7wMFzFW
         qKvCqkL6xOrIpfiZGGv2Rek/q0QcdH0GsKSOk=
Message-ID: <3666888f0807291600n3c259c20wccc4896b2df3d0d8@mail.gmail.com>
Date: Wed, 30 Jul 2008 09:00:09 +1000
From: "David Wilson" <mcs6502@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: pci_ids.h - duplicate entry and many out of order definitions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was browsing the pci_ids.h file and came across a duplicate entry
for PCI_VENDOR_ID_RDC. This prompted me to look further and I found a
number of out-of-order definitions (based on the comment at the head
of the file that indicates that they should be sorted). I decided to
write a script to check this and it found 74 "errors".

1) Is it worth my time generating a patch to fix all these mis-orderings?
2) Should it be one large patch or many small ones (eg one per PCI_VENDOR)?
3) Is there a maintainer for this file?

Here is an example of the output my script generates (on the
2.6.27-rc1 pci_ids.h file):

line 153: PCI_DEVICE_ID_COMPAQ_NETEL10	0xae34
line 154: PCI_DEVICE_ID_COMPAQ_TRIFLEX_IDE	0xae33

line 160: PCI_DEVICE_ID_COMPAQ_CISSB	0xb178
line 161: PCI_DEVICE_ID_COMPAQ_CISSC	0x46

line 193: PCI_DEVICE_ID_LSI_FC939X	0x0642
line 194: PCI_DEVICE_ID_LSI_FC949X	0x0640

line 195: PCI_DEVICE_ID_LSI_FC949ES	0x0646
line 196: PCI_DEVICE_ID_LSI_FC919X	0x0628

line 199: PCI_DEVICE_ID_LSI_63C815	0x1000
line 200: PCI_DEVICE_ID_LSI_SAS1064	0x0050

line 201: PCI_DEVICE_ID_LSI_SAS1064R	0x0411
line 202: PCI_DEVICE_ID_LSI_SAS1066	0x005E
