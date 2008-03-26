Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbYCZOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbYCZOsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYCZOsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:48:07 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:3071 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbYCZOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:48:05 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 10:48:05 EDT
Subject: ohci : strange looking use of round_jiffies_relative. possible bug
	?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: dbrownell@users.sourceforge.net
Cc: linux-usb <linux-usb@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 14:38:09 +0000
Message-Id: <1206542289.2931.17.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the uses of round_jiffies and noticed that the ohci
unlink_watchdog_func() calls 
mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));

Which looks a bit strange as it will set the timer to 0 <= t < HZ.
Reading the comments I think that is really is expecting to setup timer
to (now + 1s)

mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));

If this is not true then perhaps it needs a comment to explain what it
_is_ trying to do, because it's got me baffled ;)


Cheers
Richard



