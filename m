Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZGVBSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZGVBSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZGVBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:18:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZGVBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:18:40 -0400
Date: Tue, 21 Jul 2009 18:16:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Troy Moure <twmoure@szypr.net>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Linus Torvalds wrote:
> 
> Anyway, I bet we can work around the compiler bug by just changing the 
> type of "i" from "unsigned char" to be a plain "int".

IOW, like this.

		Linus

---
 drivers/video/fbmon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 5c1a2c0..af4a15c 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
 
 static int edid_checksum(unsigned char *edid)
 {
-	unsigned char i, csum = 0, all_null = 0;
-	int err = 0, fix = check_edid(edid);
+	unsigned csum = 0, all_null = 0;
+	int i, err = 0, fix = check_edid(edid);
 
 	if (fix)
 		fix_edid(edid, fix);
