Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZDOJN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZDOJN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZDOJNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:13:47 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:36887 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZDOJNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lWd3G8HroBHBFaOTqHJGYDzpWWzJGfbV4giT8LFF4g1hPUex83cvV3+r6ev3dL5g4V
         pXnHgTgjWnW5bHY8v5xnkkgJMpm24BgcgrVaAANKBCCsNDs3ibs6exqtpf0Nzz4lYN8D
         bOca2z6oB6G/JaUVYwbEDuMVetlVcBUgyIPZg=
MIME-Version: 1.0
Date: Wed, 15 Apr 2009 11:13:44 +0200
Message-ID: <ba4215e10904150213o628cc9d1ke80bd6dd9bfad089@mail.gmail.com>
Subject: Questions on mmc_test suite
From: Martin Fuzzey <mfuzzey@gmail.com>
To: pierre@ossman.eu
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm currently updating the mxcmmc driver for the i.MX21 platform
[patches have been posted to the arm list] and have a couple of
questions about the test suite.

1) I'm getting an error on testcase 10 (weird reads) which does reads
of 3 to 512 bytes by steps of 7.
Modifying the test so it continues in case of error shows that it
_only_ fails on the 395 byte read.

It fails with a software timeout (-110)
The card sends the same response to CMD17 (READ_SINGLE_BLOCK) as the
reads that work
but hardware never indicates transfer complete.

Changing the test to start at 395 makes it fail immediately (so not
dependent on previous reads).
Has anyone seen this before?

2) I'm getting "Warning: Host did not wait for busy state to end" on
the multiblock write tests (Tests 5 and 13) but they still pass.
Seems to be timing related since this doesn't occur with MMC debugging enabled.
My understanding of this is that the driver should wait for the
hardware to stop signalling busy on the data line (response R1b) after
sending
command 12 (stop transmission) before replying - is this correct?
However the MX2 SDHC doesn't have a register for this.

Should I:
a) ignore it? [apart from the testcase warning everything seems to work]
b) try reading the data line as GPIO  - seems a bit of a hack
c) issue CMD13 (SEND_STATUS) from the driver to poll the card  - seems
to be the wrong layer.

If b) is the way to go how long can the delay be - is polling
acceptable or must it be interrupt driven?

Regards,

Martin
