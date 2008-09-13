Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYIMKIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYIMKIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYIMKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:08:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:48034 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbYIMKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s9EHomednDWjeSgz5fEMmO8NlF5mHFNlQIdxo2BjTgeYjIpjUFgaDcOcPGgmXnh//V
         4mrQDeQMOeYfDjlPvx3Z1qFfaVm34XZp2kVdhiVaKd7qVWdOA6Gj4+W+mkwkKsyC24Ax
         kbPz+830wp+rdRcEj8o8PI3s52qQaC9RvzLdw=
Date: Sat, 13 Sep 2008 19:08:02 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] anysee: initialize anysee_usb_mutex statically
Message-ID: <20080913100801.GC3746@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anysee_usb_mutex is initialized at every time the anysee device
is probed. If the second anysee device is probed while anysee_usb_mutex
is locked by the first anysee device, the mutex is broken.

This patch fixes by initialize anysee_usb_mutex statically rather
than initialize at probe time.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: v4l-dvb-maintainer@linuxtv.org
---
 drivers/media/dvb/dvb-usb/anysee.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: 2.6-git/drivers/media/dvb/dvb-usb/anysee.c
===================================================================
--- 2.6-git.orig/drivers/media/dvb/dvb-usb/anysee.c
+++ 2.6-git/drivers/media/dvb/dvb-usb/anysee.c
@@ -43,7 +43,7 @@ module_param_named(debug, dvb_usb_anysee
 MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static struct mutex anysee_usb_mutex;
+static DEFINE_MUTEX(anysee_usb_mutex);
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)
@@ -436,8 +436,6 @@ static int anysee_probe(struct usb_inter
 	struct usb_host_interface *alt;
 	int ret;
 
-	mutex_init(&anysee_usb_mutex);
-
 	/* There is one interface with two alternate settings.
 	   Alternate setting 0 is for bulk transfer.
 	   Alternate setting 1 is for isochronous transfer.
