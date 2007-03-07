Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXCGMJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXCGMJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXCGMJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:09:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:49744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXCGMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ftlhPJCoDHhd8VQsiaQ1TQUuj3kZ9lG8IE0fUbfAm7T48LIgCCgWGg4LgrdY05Y6tihfna+vdOZBfrvm/bO6Q/lUqrJDV/JwIfN/YoYTSjkIqNMulX1QwlsjRQxNFUTFRuwOcdJkzzIfLe7umz44hWhgZvr9JRI85hfUuprUnHI=
Message-ID: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com>
Date: Wed, 7 Mar 2007 20:09:10 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [BUG] ATAPI command TEST_UNIT_READY never succeeds!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    Do you ever noticed that the ATAPI command TEST_UNIT_READY always
fails to execute !?
    I debugged in the following environments:
        piix + Intel ICH6/ICH7 PATA
        atiixp + ATI SB600 PATA
        libata + ata_piix + Intel ICH6/ICH7 PATA
        libata + sata_sil24 + Silicon Image 3132
        libata + ahci + ATI SB600 SATA
        libata + ahci + Intel AHCI
    but none of them can execute TEST_UNIT_READY command successfully.
    For example, in ahci driver, ahci_interrupt() reads port status as
0x4000_0000, which indicates an taskfile error.


Conke
