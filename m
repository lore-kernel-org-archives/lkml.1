Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265Ab0AQPjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0AQPjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422Ab0AQPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:39:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43563 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0AQPjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Db9tTUyFVxGjW/Plpcp17nJSdt/rvodQ4IpUkHveJJ2V/FGrHHX5Y7QKPpPT4kls6g
         DtETzZasfhhd1LIom7ihdF9QWvUR0wgndLyzG1z80N+xOoWOXVwD+iNnqf0IB0aO+3qa
         oUTp6o2IKvcsPn7y8lslqjjV6SKzqZPxVbCmg=
Message-ID: <4B533065.7070107@gmail.com>
Date: Sun, 17 Jan 2010 16:44:37 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rt2860/sta_ioctl.c: Two branches the same in rt_ioctl_giwscan()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the condition, the branches execute the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe this needs a different fix?

diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index d8fbe6c..de4b627 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -975,10 +975,7 @@ int rt_ioctl_giwscan(struct net_device *dev,
 		/*================================ */
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = SIOCGIWFREQ;
-		if (INFRA_ON(pAdapter) || ADHOC_ON(pAdapter))
-			iwe.u.freq.m = pAdapter->ScanTab.BssEntry[i].Channel;
-		else
-			iwe.u.freq.m = pAdapter->ScanTab.BssEntry[i].Channel;
+		iwe.u.freq.m = pAdapter->ScanTab.BssEntry[i].Channel;
 		iwe.u.freq.e = 0;
 		iwe.u.freq.i = 0;
 
