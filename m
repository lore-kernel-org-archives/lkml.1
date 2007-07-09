Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbXGIDa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbXGIDa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbXGIDas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:30:48 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:31204 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbXGIDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TtEcE0PZFtbXpTRRzsSV8hhTAG75ODTwvVLN+G+i3FAx/S8SiGbXNmNNUdoval52UG+p7LfQs/IV5tzidAYGbSr1+H3pLatcRvftAS/dHoY58+N/KY1lGIRtJB0QD15U1AVPqo0ic/YwFzFd05nyKeHXw+iDHCaPUxC7R2rjdtk=
Message-ID: <aaab98560707082030w6521f4e5qf17a01d83d20faf8@mail.gmail.com>
Date: Mon, 9 Jul 2007 11:30:46 +0800
From: "Micah Gruber" <micah.gruber@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pekkas@netcore.fi
Subject: [PATCH] [2.6.22] Remove unneeded pointer idev from addrconf_cleanup() in net/ipv6/addrconf.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch removes the unneeded pointer idev returned from
__in6_dev_get(), which is never used. The check for NULL can be simply
done by if (__in6_dev_get(dev) == NULL).

Signed-off-by: Micah Gruber < micah.gruber@gmail.com>

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4240,7 +4240,6 @@
void __exit addrconf_cleanup(void)
{
        struct net_device *dev;
-       struct inet6_dev *idev;
        struct inet6_ifaddr *ifa;
        int i;

@@ -4258,7 +4257,7 @@
         */

        for_each_netdev(dev) {
-               if ((idev = __in6_dev_get(dev)) == NULL)
+               if (__in6_dev_get(dev) == NULL)
                        continue;
                addrconf_ifdown(dev, 1);
        }
