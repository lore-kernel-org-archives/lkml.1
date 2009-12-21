Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZLUPqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZLUPqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZLUPp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:45:59 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:48764 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZLUPp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:45:58 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: "Greg Kroah-Hartman" <greg@kroah.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: BUG null dereference in driver ./drivers/usb/serial/mos7840.c
Date: Mon, 21 Dec 2009 19:51:09 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211951.09832.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.32
        SUBJECT: null derefernce in function mos7840_bulk_in_callback
        SUBSCRIBE:
        In driver drivers/usb/serial/mos7840.c in function 
mos7840_bulk_in_callback:

1. If in line 697 mos7840_port = NULL then we goto line 699
2. In line 699 we have null dereference.

 696         mos7840_port = urb->context;
 697         if (!mos7840_port) {
 698                 dbg("%s", "NULL mos7840_port pointer");
 699                 mos7840_port->read_urb_busy = false;
 700                 return;
 701         }

Found by Linux Device Drivers Verification Project (Svace Detector)
