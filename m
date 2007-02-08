Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXBHLFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXBHLFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423223AbXBHLFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:05:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51158
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423215AbXBHLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:05:33 -0500
Date: Thu, 08 Feb 2007 03:05:31 -0800 (PST)
Message-Id: <20070208.030531.112264703.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: checker-shell still hosed...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, things still fail for me even with the $(strip ...) construct
you added works properly.

For some reason things like $(call cc-option-yn...) still fail.

My make version 3.81beta4 has the space problem, and with your
change it just returns a space. :-)  Without your change it
gives the problematic " y" string.

A running theory of mine is that it's a "$(call)" within a
$(call) which generates the space.  So I wrote a little
make.test:

define test1
  $(shell echo "str1")
endef

define test2
  $(call test1)
endef

FOO := A$(call test2)B

all:
	echo A$(FOO)B

If I run "make -f make.test" I get:

davem@sunset:~/src/GIT/net-2.6$ make -f make.test
echo AA    str1BB
AA str1BB
davem@sunset:~/src/GIT/net-2.6$

Hmmm...  but I just checked on a proper "GNU Make 3.81" and that
prints the space in the example above too.

Weird...

