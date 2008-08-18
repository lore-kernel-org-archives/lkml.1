Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbYHRTlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbYHRTlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbYHRThx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:37:53 -0400
Received: from ns1.suse.de ([195.135.220.2]:48987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764543AbYHRThw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:37:52 -0400
Date: Mon, 18 Aug 2008 12:20:25 -0700
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
       alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 31/49] uml: missed kmalloc() in pcap_user.c
Message-ID: <20080818192025.GF10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-missed-kmalloc-in-pcap_user.c.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ftp.linux.org.uk>

commit 296cd66f7f6e130fe08e6880ecb13c3fc615a8db upstream

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/drivers/pcap_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -50,7 +50,7 @@ static int pcap_open(void *data)
 			return -EIO;
 		}
 
-		pri->compiled = kmalloc(sizeof(struct bpf_program),
+		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
 			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");

-- 
