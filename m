Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYBGVRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYBGVRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934480AbYBGVAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:00:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934468AbYBGVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:00:44 -0500
Date: Thu, 7 Feb 2008 13:00:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-Id: <20080207130040.7a03324e.akpm@linux-foundation.org>
In-Reply-To: <20080207150305.ZZRA012@mailhub.coreip.homeip.net>
References: <200802060108.31644.dtor@insightbb.com>
	<20080205223242.f444fad6.akpm@linux-foundation.org>
	<20080207150305.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 15:05:57 -0500
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Tue, Feb 05, 2008 at 10:32:42PM -0800, Andrew Morton wrote:
> > 
> > Looks OK.  Minorish things from a quick scan:
> > 
> 
> *ping*
> 
> Linus,
> 
> Do you want me to redo the pull or is it still acceptable as is?
> I am hesitant touching the tree after sending a pull request...
> 

That's probably me being a pain in the ass and actually looking at the pull
requests.  Sorry, I really should look at these things as they go into
people's trees, not as they attempt to come out of them.  I'll do better.

Although that's not an option with some of the stealth merges we're seeing
lately..

I'd assume that by now you can apply whatever touchups are needed then
resend the pull request.



btw:

drivers/input/touchscreen/ads7846.c: fix uninitialized var warning

From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/touchscreen/ads7846.c: In function 'ads7846_read12_ser':
drivers/input/touchscreen/ads7846.c:216: warning: 'sample' may be used uninitialized in this function

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/ads7846.c~drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning
+++ a/drivers/input/touchscreen/ads7846.c
@@ -213,7 +213,7 @@ static int ads7846_read12_ser(struct dev
 	struct ads7846		*ts = dev_get_drvdata(dev);
 	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
 	int			status;
-	int			sample;
+	int			uninitialized_var(sample);
 	int			use_internal;
 
 	if (!req)
_

