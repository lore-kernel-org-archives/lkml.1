Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab0CMA2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:28:11 -0500
Received: from kroah.org ([198.145.64.141]:32844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935046Ab0CMAVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:05 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.500692297@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 107/123] SUNRPC: Handle EINVAL error returns from the TCP connect operation
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9fcfe0c83c3b04a759cde6b8c5f961237f17808b upstream.

This can, for instance, happen if the user specifies a link local IPv6
address.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1912,6 +1912,11 @@ static void xs_tcp_setup_socket(struct r
 	case -EALREADY:
 		xprt_clear_connecting(xprt);
 		return;
+	case -EINVAL:
+		/* Happens, for instance, if the user specified a link
+		 * local IPv6 address without a scope-id.
+		 */
+		goto out;
 	}
 out_eagain:
 	status = -EAGAIN;


