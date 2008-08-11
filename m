Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYHKUvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYHKUvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYHKUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:51:31 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:15591 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYHKUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:51:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoFAPRBoEhQyAwK/2dsb2JhbACBX6o5
Date: Mon, 11 Aug 2008 22:51:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Russell King <rmk+lkml@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [WATCHDOG] v2.6.27-rc watchdog fixes
Message-ID: <20080811205124.GB26249@infomag.infomag.iguana.be>
References: <20080810204527.GF2773@infomag.infomag.iguana.be> <20080810213520.GA2847@flint.arm.linux.org.uk> <20080811183604.GA26249@infomag.infomag.iguana.be> <20080811184049.GB21967@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811184049.GB21967@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> It's in part of my general ARM updates, and I combined Adrian's three
> patches together, along with the remaining bits from my s3c2410 patch.
> Here's the mbox mail corresponding with the commit:

Applied the patch together with Ben's previously issued patches.
We now have these Changes (Ben can you test also?):

Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sun Aug 10 23:28:46 2008 +0100

    [WATCHDOG] fix watchdog/s3c2410_wdt.c compilation
    
    This patch fixes the following compile errors caused by
    commit 41dc8b72e37c514f7332cbc3f3dd864910c2a1fa
    (s3c2410_wdt watchdog driver: Locking and coding style):
    
    <--  snip  -->
    
    ...
      CC      drivers/watchdog/s3c2410_wdt.o
    s3c2410_wdt.c: In function `s3c2410wdt_start':
    s3c2410_wdt.c:161: warning: `return' with a value, in function returning void
    
    <--  snip  -->
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:51 2008 +0100

    [WATCHDOG] Fix s3c2410_wdt driver coding style issues
    
    Fixup coding style issues in the s3c2410_wdt driver.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:50 2008 +0100

    [WATCHDOG] Clean out header of s3c2410_wdt driver.
    
    Remove the changelog from the top of the driver, which
    is redundant as this information is more accurately
    represented from the revision control holding the
    file.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:49 2008 +0100

    [WATCHDOG] Fix NULL usage in s3c2410_wdt driver.
    
    Fix comparison of a pointer to 0, instead of using
    NULL for a invalid pointer.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

================================================================================
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 3da2b90..86d4280 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -21,18 +21,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Changelog:
- *	05-Oct-2004	BJD	Added semaphore init to stop crashes on open
- *				Fixed tmr_count / wdt_count confusion
- *				Added configurable debug
- *
- *	11-Jan-2005	BJD	Fixed divide-by-2 in timeout code
- *
- *	25-Jan-2005	DA	Added suspend/resume support
- *				Replaced reboot notifier with .shutdown method
- *
- *	10-Mar-2005	LCVR	Changed S3C2410_VA to S3C24XX_VA
 */
 
 #include <linux/module.h>
@@ -157,8 +145,6 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
-
-	return 0;
 }
 
 static int s3c2410wdt_set_heartbeat(int timeout)
@@ -367,7 +353,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = (res->end-res->start)+1;
+	size = (res->end - res->start) + 1;
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n");
@@ -376,7 +362,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	wdt_base = ioremap(res->start, size);
-	if (wdt_base == 0) {
+	if (wdt_base == NULL) {
 		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
 		goto err_req;
================================================================================

Greetings,
Wim.

