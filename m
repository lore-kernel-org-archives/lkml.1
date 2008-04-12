Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYDLILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYDLILG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYDLIKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:10:51 -0400
Received: from khc.piap.pl ([195.187.100.11]:55103 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbYDLIKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:10:50 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain>
	<m37if4oz1g.fsf@maximus.localdomain>
	<20080411221448.22b69ff5.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 12 Apr 2008 10:10:40 +0200
In-Reply-To: <20080411221448.22b69ff5.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 11 Apr 2008 22\:14\:48 -0700")
Message-ID: <m3prsva3y7.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> It never hurts to resend.  It was 6000 patches ago and my mind is a blank.

Sure, here is it. Some description, well:

PPP support in generic HDLC in Linux 2.6.25 is broken and will cause
a kernel panic when a device configured in PPP mode is activated.

It will be replaced by new PPP implementation after Linux 2.6.25 is
released.

This affects only PPP support in generic HDLC (mostly Hitachi SCA
and SCA-II based drivers, wanxl, and few others). Standalone syncppp
and async PPP support are not affected.

Untested :-)

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -150,9 +150,13 @@ config HDLC_FR
 
 config HDLC_PPP
 	tristate "Synchronous Point-to-Point Protocol (PPP) support"
-	depends on HDLC
+	depends on HDLC && BROKEN
 	help
 	  Generic HDLC driver supporting PPP over WAN connections.
+	  This module is currently broken and will cause a kernel panic
+	  when a device configured in PPP mode is activated.
+
+	  It will be replaced by new PPP implementation in Linux 2.6.26.
 
 	  If unsure, say N.
 
