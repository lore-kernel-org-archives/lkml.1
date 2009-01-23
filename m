Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbZAWBQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbZAWBQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZAWBOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:40 -0500
Received: from kroah.org ([198.145.64.141]:50324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755972AbZAWBOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:39 -0500
Date: Thu, 22 Jan 2009 17:11:29 -0800
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
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch 02/46] security: introduce missing kfree
Message-ID: <20090123011129.GC19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="security-introduce-missing-kfree.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vegard Nossum <vegard.nossum@gmail.com>

commit 0d54ee1c7850a954026deec4cd4885f331da35cc upstream.

Plug this leak.

Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/keyctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -270,6 +270,7 @@ long keyctl_join_session_keyring(const c
 
 	/* join the session */
 	ret = join_session_keyring(name);
+	kfree(name);
 
  error:
 	return ret;

