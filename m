Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbXKKPW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbXKKPW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXKKPWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:22:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:28812 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXKKPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Qnhuf+eMBI8ei3qKxbIWIl/Yp+LCRHduIk80v5f1flPMjddKetpxWFee4wCqKpMR0yor5anqdqmJMSfSsfRYGvnMPySAFAciH6HKoO3J3jEdFzEknX5rzY18PljtxH225lreLd48TgH+AzWepCHJA0WMHELZn27wKRyatk+L9u4=
Message-ID: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com>
Date: Mon, 12 Nov 2007 04:22:15 +1300
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: PCI card initialisation at boot
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am looking for someone to help explain my findings, which I have
searched the net but could not find any related infomation.

We have 40 linux PCs deployed in a mobile environment, so they are
subjected to pretty harsh conditions that can cause BIOS corruptions.

In one of the units, I noticed the kernel had difficulty initialising
the PCI card, with messages stating that the PCI resource/address is
invalid (I am very sorry that I did not manage to capture the exact
output). It continues to boot to userspace, but the machine hangs when
the user app tries to access the pci card.

Rebooting the PC several times gave the same message, so at least the
problem was consistent. Removing the PCI card from the slot, and
putting a spare card, solved the problem. Then, putting the first card
back worked again.

I am guessing that the ESCD has been corrupted, and putting a spare
device caused the BIOS to reset the ESCD. In the BIOS, it has been
setup as "Resource allocation by Auto(ESCD)".

There is another option in the BIOS to set "Resource allocation by
Manual". I have tried this setting and Linux has no problems booting
up and using the PCI card.

My question is: Will setting the BIOS to "Resource allocation by
Manual" prevent the crash from happening in the future? More
specifically, does Linux still depend on ESCD even if the resource
allocation is set to Manual?

Regards
Keith
