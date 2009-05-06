Return-Path: <linux-kernel-owner+w=401wt.eu-S1762373AbZEFWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762373AbZEFWCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761461AbZEFVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:38 -0400
Received: from kroah.org ([198.145.64.141]:57063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761418AbZEFVye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:58 2009
Message-Id: <20090506214757.901800675@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, paul.moore@hp.com
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
       alan@lxorguk.ukuu.org.uk, jmorris@namei.org, greg@kroah.com,
       chrisw@redhat.com, error27@gmail.com, Eugene Teo <eugeneteo@kernel.sg>
Subject: [patch 19/58] unreached code in selinux_ip_postroute_iptables_compat() (CVE-2009-1184)
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=unreached-code-in-selinux_ip_postroute_iptables_compat.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eugene Teo <eteo@redhat.com>

Not upstream in 2.6.30, as the function was removed there, making this a
non-issue.

Node and port send checks can skip in the compat_net=1 case. This bug
was introduced in commit effad8d.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Reported-by: Dan Carpenter <error27@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4661,6 +4661,7 @@ static int selinux_ip_postroute_iptables
 	if (err)
 		return err;
 	err = avc_has_perm(sk_sid, if_sid, SECCLASS_NETIF, netif_perm, ad);
+	if (err)
 		return err;
 
 	err = sel_netnode_sid(addrp, family, &node_sid);


