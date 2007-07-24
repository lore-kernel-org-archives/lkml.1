Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXGXWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXGXWSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbXGXWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:18:31 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49252 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbXGXWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:18:30 -0400
Date: Tue, 24 Jul 2007 17:19:17 -0500 (CDT)
Message-Id: <20070724.171917.30313741.yoshfuji@linux-ipv6.org>
To: rjw@sisk.pl, pavel@ucw.cz, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM:
 Introduce pm_power_off_prepare"
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Linux 2.6.23-rc1 fails to power off my ThinkPad T42.
Git-bisect told me that the following commit is to blame,
and by reverting that commit, it works appropriately.

Regards,

--yoshfuji

bd804eba1c8597cbb7cd5a5f9fe886aae16a079a is first bad commit
commit bd804eba1c8597cbb7cd5a5f9fe886aae16a079a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 19 01:47:40 2007 -0700

    PM: Introduce pm_power_off_prepare
    
    Introduce the pm_power_off_prepare() callback that can be registered by the
    interested platforms in analogy with pm_idle() and pm_power_off(), used for
    preparing the system to power off (needed by ACPI).
    
    This allows us to drop acpi_sysclass and device_acpi that are only defined in
    order to register the ACPI power off preparation callback, which is needed by
    pm_power_off() registered in a much different way.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 624870eb14bf9841fa2dca2cf13cc4c9a0479005 af79f843f3383bbecaed84d493926939cf0e1c12 M	drivers
:040000 040000 9b28a21970668ce133916bbe8d8fd4a61bce23d7 80fc84d7982369205dcf94029e3958c90db14bf0 M	include
:040000 040000 9ce5c8b5d3f87c121b2f7bc6e02bc814648a2739 2e2e1468dfa0db9dee5bd204fd3f802a975a6454 M	kernel

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
