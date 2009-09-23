Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZIWSGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZIWSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIWSGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:06:40 -0400
Received: from mail.aph.org ([205.232.169.37]:52279 "EHLO mail.aph.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZIWSGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:06:39 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 14:06:39 EDT
From: Michael Borsuk <mborsuk@aph.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Sep 2009 14:01:19 -0400
Subject: mmc_spi: command errors on 2.6.29.6
Thread-Topic: mmc_spi: command errors on 2.6.29.6
Thread-Index: AQHKPHfaGu1mxiO8y0CDt286atwKVw==
Message-ID: <A4716B7800F85942B54258E69F432FD816EDBE5705@winsrvex.aph.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am working on getting mmc_spi to work with a an ARM PXA270 on 2.6.29.6
(though I have also tried 2.6.31 with the same results).  It has worked
with some cards, but unfortunately not with one of the most common
cards, a SanDisk Ultra II MiniSD 2GB.  The card is identified but then
every command sent to it appears to return an error.  I applied all the
patches from the series posted by Wolfgang Mues but still the block card
driver reports:

  mmcblk0: error -38 sending status comand<3>mmcblk0: error -84 sending stop command, response 0x8, card status 0xff04
  mmcblk0: error -38 sending status comand<3>mmcblk0: error -38 sending read/write command, response 0x4, card status 0xff04
  end_request: I/O error, dev mmcblk0, sector 3969984

These errors continue until reaching sector 249.   The only apparent
difference after applying the patches is that the error reported is
ENOSYS instead of EINVAL.  Are there any other patches I should try or
ideas for debugging this?

-- 
Michael Borsuk
mborsuk@aph.org
502-899-2216
