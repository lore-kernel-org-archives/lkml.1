Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbZAaDOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbZAaDOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZAaCr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:56 -0500
Received: from kroah.org ([198.145.64.141]:55707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756905AbZAaCrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:49 -0500
Date: Fri, 30 Jan 2009 18:45:01 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 42/43] NET: net_namespace, fix lock imbalance
Message-ID: <20090131024501.GQ12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-net_namespace-fix-lock-imbalance.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 357f5b0b91054ae23385ea4b0634bb8b43736e83 upstream.

register_pernet_gen_subsys omits mutex_unlock in one fail path.
Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/net_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -342,8 +342,8 @@ again:
 	rv = register_pernet_operations(first_device, ops);
 	if (rv < 0)
 		ida_remove(&net_generic_ids, *id);
-	mutex_unlock(&net_mutex);
 out:
+	mutex_unlock(&net_mutex);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(register_pernet_gen_subsys);

