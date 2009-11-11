Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZKKWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZKKWU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbZKKWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:20:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:23182 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221AbZKKWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dE5pK5LZQS06XBGFZc+VrIUoVb9VlsgUPq8xLVfkiWm6TtpCn32pCBZUe4FHar5zpQ
         28C33A6Q+MzWIBSMCX47jsvhLUl6vfxLb63OOmrtOL32Z/prLU0Zo8Fi1bH20eDBap7m
         5QmOGyWsc98ziI3gHaRcaOTko/xMGk2ra7t00=
Message-ID: <4AFB3B9D.1080606@gmail.com>
Date: Wed, 11 Nov 2009 23:33:01 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] netfilter: Should xt_osf_remove_callback() return negative
 on errors?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error value

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 net/netfilter/xt_osf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

It seems strange that an error return can be positive or
negative, is this maybe required?

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 63e1905..4d1a41b 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -118,7 +118,7 @@ static int xt_osf_remove_callback(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct xt_osf_user_finger *f;
 	struct xt_osf_finger *sf;
-	int err = ENOENT;
+	int err = -ENOENT;
 
 	if (!osf_attrs[OSF_ATTR_FINGER])
 		return -EINVAL;
