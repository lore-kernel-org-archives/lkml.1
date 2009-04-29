Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbZD2WoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbZD2WoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbZD2WWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:22:07 -0400
Received: from kroah.org ([198.145.64.141]:40825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbZD2WV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:31 2009
Message-Id: <20090429220931.578718104@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:57 -0700
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
Subject: [patch 58/58] unreached code in selinux_ip_postroute_iptables_compat() (CVE-2009-1184)
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=unreached-code-in-selinux_ip_postroute_iptables_compat.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -4467,6 +4467,7 @@ static int selinux_ip_postroute_iptables
 	if (err)
 		return err;
 	err = avc_has_perm(sk_sid, if_sid, SECCLASS_NETIF, netif_perm, ad);
+	if (err)
 		return err;
 
 	err = sel_netnode_sid(addrp, family, &node_sid);


