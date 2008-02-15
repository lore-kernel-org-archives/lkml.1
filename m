Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbYBOUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbYBOUD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762709AbYBOUCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:02:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:61522 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762402AbYBOUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XFaQ7Hm2WJRV0+uD5y30sjq97UC/w/IB7gmnuUJ70Pq9w1I0sisAahT4zyg2AIJZ9xeZDOTg8CRAZqDF3B2B9OXcaW0wICKPU+ZiK45gNMQhAivMQkHflV6Ut1w+iMEVbUaHfD40FFEWmj/BC7JiLteuJD7fXbdJ5pa7jqKklew=
Subject: [PATCH 3/3] ncpfs: fix sparse warning in ncpsign_kernel.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 12:02:31 -0800
Message-Id: <1203105751.15275.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're casting anyway, might as well cast to the correct sign.
Specific to i386 (ifdef __i386__)

fs/ncpfs/ncpsign_kernel.c:58:23: warning: incorrect type in initializer (different signedness)
fs/ncpfs/ncpsign_kernel.c:58:23:    expected unsigned int *data2
fs/ncpfs/ncpsign_kernel.c:58:23:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ncpfs/ncpsign_kernel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ncpfs/ncpsign_kernel.c b/fs/ncpfs/ncpsign_kernel.c
index 749a18d..7c0b5c2 100644
--- a/fs/ncpfs/ncpsign_kernel.c
+++ b/fs/ncpfs/ncpsign_kernel.c
@@ -55,7 +55,7 @@ static void nwsign(char *r_data1, char *r_data2, char *outdata) {
  unsigned int w0,w1,w2,w3;
  static int rbit[4]={0, 2, 1, 3};
 #ifdef __i386__
- unsigned int *data2=(int *)r_data2;
+ unsigned int *data2=(unsigned int *)r_data2;
 #else
  unsigned int data2[16];
  for (i=0;i<16;i++)
-- 
1.5.4.1.1278.gc75be

