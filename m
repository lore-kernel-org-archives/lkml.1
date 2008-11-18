Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKRPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKRPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYKRPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:42:51 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:12976 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKRPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=eJSy4FtBmUl8AJVvd+VnjJrpLCqh3q/eyC8u7OM0cIA15G00Jjrg3ORtOymZgKCugN
         mt4E+wicQSvhTIHfIul9TRopIheap23fEWiIuD+xcen65INFDcrXkhX/suC5PtBVZ/2M
         ra0Kq+2/LRT0oZ2mVhsl69Ego727FrqkWUqkw=
Message-ID: <efeafa350811180733h6115dbc9t5a33abf55e774388@mail.gmail.com>
Date: Tue, 18 Nov 2008 16:33:31 +0100
From: Lazy <lazy404@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: AHCI backplane errors in 2.6.27
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.27-rc1 kernel on out intel SR1530HSH ( Quad core Xeon X3320)
Sata controller is ICH9r running in AHCI mode with newest bios.

After loading ahci driver backplane leds go amber which indicates a
non fatal error according to my intel resseller.

Everything works fine, there is no degradation in performance and
system boots up and runs correctly (for about 15 minutes after that we
went back to the old kernel).

I traced it to (introduced in 2.6.27-rc1):

commit b312bf359e20cc39c00d480fd40a24c245d80bf7
Merge: dc221ea... 2640d7c...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 15 11:18:10 2008 -0700

    Merge branch 'upstream-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev

    * 'upstream-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev:
      AHCI: Remove an unnecessary flush from ahci_qc_issue
      AHCI: speed up resume
      [libata] Add support for VPD page b1
      ata: endianness annotations in pata drivers
      libata-eh: update atapi_eh_request_sense() to take @dev instead of @qc
      [libata] sata_svw: update code comments relating to data corruption
      libata/ahci: enclosure management support
      libata: improve EH internal command timeout handling
      libata: use ULONG_MAX to terminate reset timeout table
      libata: improve EH retry delay handling
      libata: consistently use msecs for time durations

my best gues whould be
      libata/ahci: enclosure management support

I am unable to separate this patches now. Will try some giting tomorrow.

-- 
Michal Grzeidzicki
