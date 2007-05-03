Return-Path: <linux-kernel-owner+w=401wt.eu-S1767388AbXECF37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767388AbXECF37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 01:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767393AbXECF37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 01:29:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:5690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767388AbXECF36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 01:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=gFFpcMA59fr7ZRvjn4ecDnUnzggeOmpGoO5XSB0emVigKtWjIAoLawoMSQsTcHVWrLYZmwKKfkHHPj3ZOHo56m+kK8igSHCB7Gku6wKmYF3raP+qkieu7psEFJOybcAVK9AGgCSLoC2QdE9iQ6ktIEqzhz1tCe7d8/QcMu7aU8c=
Date: Thu, 3 May 2007 13:34:29 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: thomas@winischhofer.net, akpm@osdl.org
Cc: LKML <linux-kernel@vger.kernel.org>, Wang Ya-gang <lazy_linux@126.com>,
       Chen Li-jun <cljun@xiyou.edu.cn>
Subject: [Patch][SIS USB2VGA] Warning fix
Message-ID: <20070503053429.GA3166@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: thomas@winischhofer.net, akpm@osdl.org,
	LKML <linux-kernel@vger.kernel.org>,
	Wang Ya-gang <lazy_linux@126.com>, Chen Li-jun <cljun@xiyou.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this warning:
drivers/usb/misc/sisusbvga/sisusb_con.c:1436: warning: initialization from incompatible pointer type


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
---

Compiling test past.;)


--- linux-2.6.21-rc7-mm2/drivers/usb/misc/sisusbvga/sisusb_con.c.orig	2007-05-03 02:51:06.000000000 +0800
+++ linux-2.6.21-rc7-mm2/drivers/usb/misc/sisusbvga/sisusb_con.c	2007-05-03 02:57:08.000000000 +0800
@@ -321,9 +321,10 @@ sisusbcon_deinit(struct vc_data *c)
 /* interface routine */
 static u8
 sisusbcon_build_attr(struct vc_data *c, u8 color, u8 intensity,
-			    u8 blink, u8 underline, u8 reverse)
+			    u8 blink, u8 underline, u8 reverse, u8 unused)
 {
 	u8 attr = color;
+	(void) unused;
 
 	if (underline)
 		attr = (attr & 0xf0) | c->vc_ulcolor;
