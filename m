Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbZDAOMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbZDAOMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765927AbZDAOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37779 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932246AbZDAOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 16/24] isicom: isicom kref leak fix
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:41 +0100
Message-ID: <20090401140638.22882.49415.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The isicom driver leaks a kref on the shutdown path. Drop the additional
kref we took

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/isicom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 24aa6e8..a59eac5 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -925,6 +925,7 @@ static void isicom_shutdown_port(struct isi_port *port)
 		if (!card->count)
 			isicom_shutdown_board(card);
 	}
+	tty_kref_put(tty);
 }
 
 static void isicom_flush_buffer(struct tty_struct *tty)

