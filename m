Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZERUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZERUiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZERUiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:38:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49070 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZERUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L8KcaReI0kgLKp+/CIWd+AOgEI5m4p9r1AT4XAuO+0V+1ksIexPv/wf1r565iLcLjS
         BQi8StqM8mnTUiFWUQgYVNU5kZWCLMBQou5RBi+Ce8otkbXeZ4qmqR/i9jtnNXAvmEZd
         56kefUgAf8Ay5kthK3Vn3YG6QGssDSmsyXiOA=
MIME-Version: 1.0
Date: Mon, 18 May 2009 22:38:08 +0200
Message-ID: <63386a3d0905181338l2ce5bd9er9f6e4470e3656dd9@mail.gmail.com>
Subject: [PATCH 0/1] MFD: Add U300 AB3100 core support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog from v1 -> v2:

* use dynamically allocated struct ab3100 holder for
  state encapsulation.

* Create sub-platform_devices for all the devices found
  inside the AB3100. This is done after init, and all
  drivers have to pass the driver_data back in order
  to call back into ab3100-core. I also define a resource
  containing the register range applicable for each
  functionality so that it is actually possible to
  limit register access to the appropriate registers for
  each sub-device sometime further down the road.

* Since all sub-devices are initialized after the AB3100,
  the initialization check could be removed from all
  symbols.

* Converted the callback into a broadcasting notifier,
  simplifying that code quite a bit by catenating the
  event flags into a 24-bit field passed as value to
  the listeners for masking and reacting to the proper
  events.

* Register a secondary dummy I2C client for performing
  test register operations.

* const on AB3100 debugfs file operations struct.

* free_irq() on the IRQ.


Linus Walleij
