Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXBVK2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXBVK2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXBVK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:28:12 -0500
Received: from mail2.ameuro.de ([195.140.232.8]:51258 "EHLO mail2.ameuro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945961AbXBVK2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:28:11 -0500
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 05:28:11 EST
Date: Thu, 22 Feb 2007 10:57:47 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux
 2.6.21-rc1)
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <87abz75hzs.fsf@duaron.myhome.or.jp>
	<20070222001809.GB30444@kroah.com>
In-Reply-To: <20070222001809.GB30444@kroah.com> (from greg@kroah.com on Thu
	Feb 22 01:18:09 2007)
X-Mailer: Balsa 2.3.14
Message-Id: <1172138267l.24074l.0l@ecxwww1.reanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-AEV-Kundenmail-Information: AEV Virus and Spam Secure Mail System
X-AEV-Kundenmail-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-02-22 01:18:09, Greg KH wrote:
> On Thu, Feb 22, 2007 at 06:16:23AM +0900, OGAWA Hirofumi wrote:
> > E.g. something calls the request_modle(), and if hotplug is using
> > socket(PF_UNIX) and af_unix is module, it also calls request_modle()?
> > 
> > Just my guess though...
> 
> Ugh, why does anyone make af_unix a module these days.  I thought only
> Debian was that foolish...  :)

Then how about making CONFIG_UNIX bool instead of tristate?

Cheers
 Anders

diff --git a/net/unix/Kconfig b/net/unix/Kconfig
index 5a69733..b589254 100644
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -3,7 +3,7 @@
 #

 config UNIX
-       tristate "Unix domain sockets"
+       bool "Unix domain sockets"
        ---help---
          If you say Y here, you will include support for Unix domain sockets;
          sockets are the standard Unix mechanism for establishing and
@@ -13,9 +13,5 @@ config UNIX
          an embedded system or something similar, you therefore definitely
          want to say Y here.

-         To compile this driver as a module, choose M here: the module will be
-         called unix.  Note that several important services won't work
-         correctly if you say M here and then neglect to load the module.
-
          Say Y unless you know what you are doing.


