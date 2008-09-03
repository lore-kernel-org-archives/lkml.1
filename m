Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYICRq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYICRq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYICRqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:46:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbYICRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:46:45 -0400
Date: Wed, 3 Sep 2008 10:26:47 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-nfs@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       David Richter <richterd@citi.umich.edu>
Subject: [patch 39/42] nfsd: fix buffer overrun decoding NFSv4 acl
Message-ID: <20080903172647.GN7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd-fix-buffer-overrun-decoding-nfsv4-acl.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 91b80969ba466ba4b915a4a1d03add8c297add3f upstream

The array we kmalloc() here is not large enough.

Thanks to Johann Dahm and David Richter for bug report and testing.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: David Richter <richterd@citi.umich.edu>
Tested-by: Johann Dahm <jdahm@umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -443,7 +443,7 @@ init_state(struct posix_acl_state *state
 	 * enough space for either:
 	 */
 	alloc = sizeof(struct posix_ace_state_array)
-		+ cnt*sizeof(struct posix_ace_state);
+		+ cnt*sizeof(struct posix_user_ace_state);
 	state->users = kzalloc(alloc, GFP_KERNEL);
 	if (!state->users)
 		return -ENOMEM;

-- 
