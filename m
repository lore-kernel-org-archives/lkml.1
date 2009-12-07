Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZLGNWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZLGNWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZLGNWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:22:12 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35359 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbZLGNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VM7iU3K10hQZiPV0AvoAwZ4MsQhxLW8o5s6yRvtgRi4rY/Od6hp1vSqo8s4CA1BfQj
         WWEdLwF6fB/NtXiDJ3h2awxtkWdzoWEALUYfAl9NPmheveMjJjtVTXxekXjUNT63+sDr
         9PGyPyT1E4rF1kivKBB9R5+YbrWr4NSPq/pvQ=
Message-ID: <4B1D01C9.3070305@gmail.com>
Date: Mon, 07 Dec 2009 14:23:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] HID: PTR_ERR return of wrong pointer in hidp_setup_hid()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 net/bluetooth/hidp/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 49d8495..eae872c 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -763,7 +763,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 
 	hid = hid_allocate_device();
 	if (IS_ERR(hid))
-		return PTR_ERR(session->hid);
+		return PTR_ERR(hid);
 
 	session->hid = hid;
 	session->req = req;
