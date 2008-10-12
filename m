Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYJLLJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYJLLJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJLLJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:09:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYJLLJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:09:20 -0400
Date: Sun, 12 Oct 2008 13:09:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: fix build on !CONFIG_KEYS
Message-ID: <20081012110904.GA581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

find a quick build fix for CIFS below - you might have it already. 
Please double-check.

	Ingo

----------->
>From 9d65371d47bc0285a557f279d402764f73551d3c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 12 Oct 2008 13:01:52 +0200
Subject: [PATCH] cifs: fix build on !CONFIG_KEYS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

CIFS has keys infrastructure dependencies:

  fs/cifs/sess.c: In function ‘CIFS_SessSetup’:
  fs/cifs/sess.c:628: error: implicit declaration of function ‘key_revoke’

So express that dependency in the Kconfig.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 40183d9..c0eade5 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1876,6 +1876,7 @@ config SMB_NLS_REMOTE
 config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
+	depends on KEYS
 	select NLS
 	help
 	  This is the client VFS module for the Common Internet File System
