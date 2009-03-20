Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZCTL7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZCTL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZCTL6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:58:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:46151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZCTL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PAm15vDZCj4x352pUqmWIOwH+/Ziuk4bmSW5BtcmvGZ+nmW2xS9Sp8E/Gy7vue1SgL
         PJqwygkPZ+5pOOFjV6weuzV5asVGhLna/eh5nCMlzHdxo++/ztqNh5T43zvLu+Mv3o8e
         cFrnDi6sdr8qwLq6+8dv8WaSeurIcI22ToF+w=
Date: Fri, 20 Mar 2009 14:58:38 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Phonet:fix build problem
Message-ID: <20090320115838.GA26371@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/phonet/pep.c: In function 'pipe_rcv_status':
net/phonet/pep.c:262: error: lvalue required as left operand of assignment

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 net/phonet/pep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 8ad2b53..9a1aefa 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -259,7 +259,8 @@ static int pipe_rcv_status(struct sock *sk, struct sk_buff *skb)
 	case PN_PEP_IND_ID_MCFC_GRANT_CREDITS:
 		if (pn->tx_fc != PN_MULTI_CREDIT_FLOW_CONTROL)
 			break;
-		atomic_add(wake = hdr->data[4], &pn->tx_credits);
+		wake = hdr->data[4];
+		atomic_add(wake, &pn->tx_credits);
 		break;
 
 	default:
