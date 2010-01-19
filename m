Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582Ab0ASVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0ASVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458Ab0ASVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:45:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52013 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0ASVp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nnSUi+CuhOn1EVEFn3SQ04TTPBZWwalyY9YsoCNZmNHVRd68K19I/4dkE1Md59B4T+
         34avaUl87Kug59+jFxerYQbR1yej7hoj2OCqoTsWyXOwarvrrstFDOCGk+pCG2UAjY2/
         Xh9rRZYN/mCDTcNPifehZ7H5ekx6ob1U0CuKM=
Message-ID: <4B56291D.2000304@gmail.com>
Date: Tue, 19 Jan 2010 22:50:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [NETLINK]: With opcode INET_DIAG_BC_S_LE dport was compared
 in inet_diag_bc_run()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s-port should be compared.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I presume?

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index bdb78dd..1aaa811 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -368,7 +368,7 @@ static int inet_diag_bc_run(const void *bc, int len,
 			yes = entry->sport >= op[1].no;
 			break;
 		case INET_DIAG_BC_S_LE:
-			yes = entry->dport <= op[1].no;
+			yes = entry->sport <= op[1].no;
 			break;
 		case INET_DIAG_BC_D_GE:
 			yes = entry->dport >= op[1].no;
