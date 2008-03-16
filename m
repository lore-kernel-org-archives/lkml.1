Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYCPSoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYCPSoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYCPSnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:43:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49530 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbYCPSnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:43:52 -0400
X-Sasl-enc: toO0w5CMqxoJs9YI634U+Jj7+LvunJvMyIYUX0uFU5/f 1205693031
Date: Sun, 16 Mar 2008 15:43:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080316184349.GA28543@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Richard,

Is the use of "if (preempt_count())" to know when to defer led gpio work to
a workqueue needed?  Shouldn't "if (in_atomic())" be enough?

I have found no other such uses of preempt_count() anywhere in kernel code,
while in_atomic() is used for that sort of heuristic in various places.

Relevant git commit id is: 00852279af5ad26956bc7f4d0e86fdb40192e542
"leds: Teach leds-gpio to handle timer-unsafe GPIOs".   It made mainline in
2.6.23-rc1.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
