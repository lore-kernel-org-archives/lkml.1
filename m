Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZJTRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZJTRyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZJTRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:54:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28760 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZJTRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xYsT3ivc/wl6I7Ks9lDSi10KIWgb3kx07/Ptsokm6Wogw6TPdJDEEWO4qSMxF+jhEn
         DUKQHTdV+RWujVCRWZNWB9eoFZVfSXqW4VRPgv9+tfmROre3/IQvrz7ACLyWoF53FaaI
         byTb+lV54KWDfrHA1Bza8pvkPl+dpoUiKAbKc=
Message-ID: <4ADDFB98.1060004@gmail.com>
Date: Tue, 20 Oct 2009 20:04:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] frv: Fix check on unsigned in do_signal()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscallno is unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this maybe intended?

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 6b0a2b6..0974c0e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -527,7 +527,7 @@ static void do_signal(void)
 
 no_signal:
 	/* Did we come from a system call? */
-	if (__frame->syscallno >= 0) {
+	if (__frame->syscallno != -1) {
 		/* Restart the system call - no handlers present */
 		switch (__frame->gr8) {
 		case -ERESTARTNOHAND:
