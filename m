Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070Ab0AQPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0AQPFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918Ab0AQPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:05:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:59752 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0AQPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qQdJ07AvugWaKT1L7yxIkq27QoZCJWarE3pSyIYsHJAWTKCCgDqBXVoLVQWJfz+Va/
         Xe4PesVzlai370RtbKlphUjyEZF24zDiG0QdCtATA+J1uIkgJSSqMfs3xYDcgIHdDfuX
         MRxrLdCFhmaHIinF/jyT3D1AK1P1mphLsVDc8=
Message-ID: <4B53284C.1090405@gmail.com>
Date: Sun, 17 Jan 2010 16:10:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] S2io: two branches the same in wait_for_cmd_complete()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the bit_state, the branches execute the same code.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/s2io.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

Maybe something else was intended?
this was introduced in commit 9fc93a41a1ad11

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index cc42186..0e353d6 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3415,16 +3415,9 @@ static int wait_for_cmd_complete(void __iomem *addr, u64 busy_bit,
 
 	do {
 		val64 = readq(addr);
-		if (bit_state == S2IO_BIT_RESET) {
-			if (!(val64 & busy_bit)) {
-				ret = SUCCESS;
-				break;
-			}
-		} else {
-			if (!(val64 & busy_bit)) {
-				ret = SUCCESS;
-				break;
-			}
+		if (!(val64 & busy_bit)) {
+			ret = SUCCESS;
+			break;
 		}
 
 		if (in_interrupt())
