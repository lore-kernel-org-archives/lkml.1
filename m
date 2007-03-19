Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXCSJWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXCSJWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXCSJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:22:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34811 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbXCSJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:21:59 -0400
Date: Mon, 19 Mar 2007 10:22:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Patrick Caulfield <pcaulfie@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org
Subject: fs/dlm/lowcomms-tcp.c: error handling bug
Message-ID: <20070319092202.GF752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that the following part of
commit bd44e2b007bc9024bce3357c185b38c73f87c3dd is obviously bogus:

<--  snip  -->

--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -327,6 +327,9 @@ static int receive_from_sock(struct connection *con)
 
        if (ret <= 0)
                goto out_close;
+       if (ret == -EAGAIN)
+               goto out_resched;
+
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

