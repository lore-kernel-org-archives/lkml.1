Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbZAaDJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbZAaDJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZAaCrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:45 -0500
Received: from kroah.org ([198.145.64.141]:55504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757068AbZAaCrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:36 -0500
Date: Fri, 30 Jan 2009 18:44:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Magnus Damm <damm@igel.co.jp>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 29/43] gpiolib: fix request related issue
Message-ID: <20090131024422.GD12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="gpiolib-fix-request-related-issue.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Magnus Damm <damm@igel.co.jp>

commit 7460db567bbca76bf087d1694d792a1a96bdaa26 upstream.

Fix request-already-requested handling in gpio_request().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/gpiolib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
 	} else {
 		status = -EBUSY;
 		module_put(chip->owner);
+		goto done;
 	}
 
 	if (chip->request) {

