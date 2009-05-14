Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZENW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZENW40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZENWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:51 -0400
Received: from kroah.org ([198.145.64.141]:52585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZENWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:27 2009
Message-Id: <20090514223527.119426054@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:16 -0700
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
       alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>
Subject: [patch 41/51] dmatest: fix max channels handling
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=dmatest-fix-max-channels-handling.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit c56c81abe7e684bc6203632d807303eb765690dc upstream.

The check for reaching max_channels is short circuited by 'continuing'
after successfully adding a channel.

[ Impact: make the 'max_channels' module parameter actually have an effect ]

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/dmatest.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -410,9 +410,7 @@ static int __init dmatest_init(void)
 		chan = dma_request_channel(mask, filter, NULL);
 		if (chan) {
 			err = dmatest_add_channel(chan);
-			if (err == 0)
-				continue;
-			else {
+			if (err) {
 				dma_release_channel(chan);
 				break; /* add_channel failed, punt */
 			}


