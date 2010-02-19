Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0BSRKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:10:47 -0500
Received: from kroah.org ([198.145.64.141]:57602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0BSRAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:44 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:44 2010
Message-Id: <20100219163244.163206237@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [48/93] netfilter: nf_conntrack: restrict runtime expect hashsize modifications
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 13ccdfc2af03e09e60791f7d4bc4ccf53398af7c upstream.

Expectation hashtable size was simply glued to a variable with no code
to rehash expectations, so it was a bug to allow writing to it.
Make "expect_hashsize" readonly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_expect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -569,7 +569,7 @@ static void exp_proc_remove(struct net *
 #endif /* CONFIG_PROC_FS */
 }
 
-module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0600);
+module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0400);
 
 int nf_conntrack_expect_init(struct net *net)
 {


