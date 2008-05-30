Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYE3VBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYE3VBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYE3VBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:01:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:60621 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYE3VBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=YQK4T5/+DoxnfTten1amv5bbni8Q+rHFcC5kTZVkfjv9jO94WdNBnPpilkuCJ28zmzO3O919Fvhz+f3T83YktVz27PcNSBJXVRZ3DX+fVYuFAozHOvRBfY6vq5SmZH3hg4JosyNWtwo3vgBhvPwMUSjHSE33BuZ9EFJ+6R822Gc=
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: "BUG: unable to handle kernel paging request" on shutdown or killing NetworkManager in latest wireless-testing (with rt73usb wireless adapter)
Date: Fri, 30 May 2008 23:06:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <69e28c910805301336m319f6134i11f999d56b740314@mail.gmail.com>
In-Reply-To: <69e28c910805301336m319f6134i11f999d56b740314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805302306.48653.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I have just compiled a kernel from wireless-testing (32-bit x86), and
> I get this during shutdown or if I kill NetworkManager (blacklisting
> rt73usb fixes it):

Could you try below patch to see if that works?

Ivo

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 58d1633..63381cf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -347,8 +347,11 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Kill guardian urb.
+	 * Kill guardian urb (if required by driver).
 	 */
+	if (!test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
+		return;
+
 	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
 		bcn_priv = rt2x00dev->bcn->entries[i].priv_data;
 		if (bcn_priv->guardian_urb)
