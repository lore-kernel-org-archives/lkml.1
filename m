Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYIXXFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYIXXFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYIXXEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:04:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:55709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYIXXEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:04:37 -0400
Date: Wed, 24 Sep 2008 16:01:13 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       Jeff Mahoney <jeffm@suse.de>
Subject: [patch 02/04] Staging: add TAINT_CRAP flag to drivers/staging
	modules
Message-ID: <20080924230113.GC27730@suse.de>
References: <20080924224638.514504825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="staging-add-taint_crap-flag-to-drivers-staging-modules.patch"
In-Reply-To: <20080924230054.GA27730@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to add a flag for all code that is in the drivers/staging/
directory to prevent all other kernel developers from worrying about
issues here, and to notify users that the drivers might not be as good
as they are normally used to.

Based on code from Andreas Gruenbacher and Jeff Mahoney to provide a
TAINT flag for the support level of a kernel module in the Novell
enterprise kernel release.

This is the code that actually modifies the modules, adding the flag to
any files in the drivers/staging directory.

Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeff Mahoney <jeffm@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---

 scripts/mod/modpost.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1726,6 +1726,14 @@ static void add_header(struct buffer *b,
 	buf_printf(b, "};\n");
 }
 
+void add_staging_flag(struct buffer *b, const char *name)
+{
+	static const char *staging_dir = "drivers/staging";
+
+	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0)
+		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
+}
+
 /**
  * Record CRCs for unresolved symbols
  **/
@@ -2133,6 +2141,7 @@ int main(int argc, char **argv)
 		buf.pos = 0;
 
 		add_header(&buf, mod);
+		add_staging_flag(&buf, mod->name);
 		err |= add_versions(&buf, mod);
 		add_depends(&buf, mod, modules);
 		add_moddevtable(&buf, mod);

-- 
