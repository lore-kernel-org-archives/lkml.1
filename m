Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbXJQTi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbXJQTi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXJQTit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:38:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXJQTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:38:47 -0400
Date: Wed, 17 Oct 2007 15:38:39 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: reduce frequency of cursor blinking
Message-ID: <20071017193839.GD9748@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Antonino Daplas <adaplas@gmail.com>
References: <20071016181911.GA24428@redhat.com> <20071016113037.2fa3cd6f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016113037.2fa3cd6f@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:30:37AM -0700, Arjan van de Ven wrote:
 > On Tue, 16 Oct 2007 14:19:11 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > Depending on CONFIG_HZ, we blink the cursor at 20,50,60 or 200Hz.
 > 
 > eh no, that's 5 times per second ...

Indeed. Still seems excessive though.
How about twice per second ?

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 73813c6..7d9bae5 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -433,7 +433,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	schedule_work(&info->queue);
-	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
+	mod_timer(&ops->cursor_timer, jiffies + HZ/2);
 }
 
 static void fbcon_add_cursor_timer(struct fb_info *info)
-- 
http://www.codemonkey.org.uk
