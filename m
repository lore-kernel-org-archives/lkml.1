Return-Path: <linux-kernel-owner+w=401wt.eu-S935305AbZLMB6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935305AbZLMB6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935295AbZLMB6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:58:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55009 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935292AbZLMB6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rm7SsQc4+hb6noHCyR8urtpf6f6ui0ZixVVUocLQkIFPB4nXLRc9A1h1PdhfimPJ26
         UriqG1jGUhqq217XaHTSQ3k/7Z/dOfxbMS0nsbeKqy2GfDm6EeBq0urKBgZC63S7SmeL
         HEnTSALBwXeoGC/pDGFNG13XzioGtlkB6Q/84=
Message-ID: <4B23EA51.30504@gmail.com>
Date: Sat, 12 Dec 2009 20:09:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, yevgenyp@mellanox.co.il,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mlx4_core: return a negative error value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value should be negative.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/mlx4/sense.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This is a cleanup, its only caller, mlx4_do_sense_ports()
acts on any non-zero error values as well.

diff --git a/drivers/net/mlx4/sense.c b/drivers/net/mlx4/sense.c
index f36ae69..015fbe7 100644
--- a/drivers/net/mlx4/sense.c
+++ b/drivers/net/mlx4/sense.c
@@ -53,7 +53,7 @@ static int mlx4_SENSE_PORT(struct mlx4_dev *dev, int port,
 
 	if (out_param > 2) {
 		mlx4_err(dev, "Sense returned illegal value: 0x%llx\n", out_param);
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	*type = out_param;
