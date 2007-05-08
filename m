Return-Path: <linux-kernel-owner+w=401wt.eu-S967533AbXEHAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967533AbXEHAZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967468AbXEHAZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:25:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:22347 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967465AbXEHAZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IcE22Ba2OrkrppcHItQ+e4jxHCZzxXoCS71wSzQN/GMHU4K/IbqFZ84ujInQWMI+ZC/OKbVgan3bnZrl6kw4m+/cm8w5d1qb6meEHJQhYmR+hYbPVDUFT4hoHI+3lunOOWa8olDvRQkS4/lJeggm52ogTBKMgDIiVwDg3egMCRU=
Message-ID: <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
Date: Tue, 8 May 2007 05:55:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: chris@pcburn.com
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <463FB6B0.3070005@pcburn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463FB6B0.3070005@pcburn.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Chris Bergeron <chris@pcburn.com> wrote:
> On trying to build a 2.6.21.1 kernel using the configuration at
> http://pcburn.com/files/kernel/breaks.2.6.21.1.config I'm getting the
> following error with Networking Support -> Bluetooth Subsystem Support
> -> HIDP protocol support set to built-in:
>
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `hidp_add_connection':
> (.text+0x8bb08): undefined reference to `hid_ff_init'
> make: *** [.tmp_vmlinux1] Error 1

You've got CONFIG_BT_HIDP=y there but CONFIG_USB_HID=m. The trivial
patch below solves it. To test, you can just "make oldconfig" on the
same .config that broke above and then proceed to make bzImage.

Satyam

---

Make CONFIG_BT_HIDP depend on CONFIG_USB_HID and CONFIG_HID_FF.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

 net/bluetooth/hidp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff -ruNp a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
--- a/net/bluetooth/hidp/Kconfig	2007-04-26 08:38:32.000000000 +0530
+++ b/net/bluetooth/hidp/Kconfig	2007-05-08 05:40:58.000000000 +0530
@@ -1,6 +1,6 @@
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT && BT_L2CAP && INPUT
+	depends on BT && BT_L2CAP && INPUT && USB_HID && HID_FF
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
