Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYELWOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYELWOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYELWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:14:11 -0400
Received: from vena.lwn.net ([206.168.112.25]:37977 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYELWOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:14:10 -0400
To: linux-kernel@vger.kernel.org
Subject: V4L2-based build error
cc: mchehab@infradead.org
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 12 May 2008 16:14:09 -0600
Message-ID: <18844.1210630449@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you configure V4L2 as a module, the config system will still let you
configure DVB_CORE built-in.  This yields:

  drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
  tuner-core.c:(.text+0x901d5): undefined reference to `v4l2_i2c_attach'
  drivers/built-in.o: In function `tuner_command':
  tuner-core.c:(.text+0x91aed): undefined reference to `v4l_printk_ioctl'

I never had trouble with this before 2.6.26-rc2.  I'm happy making
DVB_CORE modular, but it would be nice if the config system didn't allow
inconsistent setups.

jon

P.S. As I was digging into this, I ran into <media/v4l2-i2c-drv-legacy.h>, 
     which takes an interesting approach - function definitions and 
     module_init() within a header file?  This thing is included in a 
     number of places; it seems like there should be a better way...

