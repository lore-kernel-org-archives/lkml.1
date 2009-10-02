Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbZJBBtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbZJBBtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZJBBti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:49:38 -0400
Received: from kroah.org ([198.145.64.141]:33240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbZJBBd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:17 2009
Message-Id: <20091002012417.363241174@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Machek <pavel@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>
Subject: [070/136] [ARM] pxa/sharpsl_pm: zaurus c3000 aka spitz: fix resume
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=pxa-sharpsl_pm-zaurus-c3000-aka-spitz-fix-resume.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pavel Machek <pavel@ucw.cz>

commit 99f329a2ba3c2d07cc90ca9309babf27ddf98bff upstream.

sharpsl_pm.c code tries to read battery state very early during
resume, but those battery meters are connected on SPI and that's only
resumed way later.

Replace the check with simple checking of battery fatal signal, that
actually works at this stage.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Stanislav Brabec <utx@penguin.cz>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/sharpsl_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -678,8 +678,8 @@ static int corgi_enter_suspend(unsigned 
 		dev_dbg(sharpsl_pm.dev, "User triggered wakeup in offline charger.\n");
 	}
 
-	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || (sharpsl_fatal_check() < 0) )
-	{
+	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) ||
+	    (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_FATAL)))	{
 		dev_err(sharpsl_pm.dev, "Fatal condition. Suspend.\n");
 		corgi_goto_sleep(alarm_time, alarm_enable, state);
 		return 1;


