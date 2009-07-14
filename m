Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZGNWyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZGNWyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbZGNWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:54:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2137 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZGNWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:54:42 -0400
Subject: Re: [PATCH] MAINTAINERS: Coalesce name and email address lines
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       sam@ravnborg.org, pavel@ucw.cz, randy.dunlap@oracle.com
In-Reply-To: <20090714154021.a8b0dfb7.akpm@linux-foundation.org>
References: <cover.1247517373.git.joe@perches.com>
	 <1247522300.4008.37.camel@Joe-Laptop.home>
	 <20090714154021.a8b0dfb7.akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-uhZgQI1RIN04AuTa62Nv"
Date: Tue, 14 Jul 2009 15:54:03 -0700
Message-Id: <1247612043.18411.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uhZgQI1RIN04AuTa62Nv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-07-14 at 15:40 -0700, Andrew Morton wrote:
> On Mon, 13 Jul 2009 14:58:19 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2009-07-13 at 14:14 -0700, Joe Perches wrote:
> > > A collection of cleanup patches to MAINTAINERS
> > 
> > I ran the script I submitted awhile back on MAINTAINERS
> > after these [0/16] patches are applied.
> > 
> > http://lkml.org/lkml/2009/6/1/275
> > 
> > I think the result is useful for people that rely
> > on copy and paste of email addresses.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> >  MAINTAINERS | 2722 ++++++++++++++++++++---------------------------------------
> >  1 files changed, 908 insertions(+), 1814 deletions(-)
> 
> I don't think I want to have to maintain this patch for more than eight
> minutes.

Neither would I...

> Please send me a copy of that script so I can regenerate the patch when
> it breaks.  I'll include it in the changelog of the patch, because
> there's a decent chance that the patch will get broken during just the
> several-hour lag between me pulling Linus's tree and sending patches at
> him.

Thanks.  I wanted to get feedback though, so I sent the result.

Here's the script inline and as an attachment.

I've removed handling for the removed Cirrus Logic section
and fixed a complaint about recent fuzz with stgit.

diff --git a/integrate_maintainers.sh b/integrate_maintainers.sh
new file mode 100755
index 0000000..b8ac2fa
--- /dev/null
+++ b/integrate_maintainers.sh
@@ -0,0 +1,34 @@
+#! /bin/sh
+#
+# Change MAINTAINERS from
+#	P: name
+#	M: address
+# to:
+#	M: name <address>
+#
+# Integrate P: and M: lines
+#
+perl -i -e 'local $/; while(<>) { s@P:	([^\n]+)\nM:	([^\n]+)\n@M:	\1 <\2>\n@g; print; }' MAINTAINERS
+#
+# Quote names with periods, commas and parentheses
+#
+sed -r -i -e "s/^M:	(.+)([\.,'\(])(.*) </M:	\"\1\2\3\" </g" MAINTAINERS
+#
+# Add a description of email name style
+#
+patch -p1 <<EOF
+diff --git a/MAINTAINERS b/MAINTAINERS
+--- a/MAINTAINERS
++++ b/MAINTAINERS
+@@ -73,8 +73,8 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
+ order. If you could add yourselves to it in alphabetical order that would be
+ so much easier [Ed]
+ 
+-P: Person
+-M: Mail patches to
++P: Person (obsolete)
++M: Mail patches to: FullName <address@domain>
+ L: Mailing list that is relevant to this area
+ W: Web-page with status/info
+ T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+EOF



--=-uhZgQI1RIN04AuTa62Nv
Content-Disposition: attachment; filename="integrate_maintainers.sh"
Content-Type: application/x-shellscript; name="integrate_maintainers.sh"
Content-Transfer-Encoding: 7bit

#! /bin/sh
#
# Change MAINTAINERS from
#	P: name
#	M: address
# to:
#	M: name <address>
#
# Integrate P: and M: lines
#
perl -i -e 'local $/; while(<>) { s@P:	([^\n]+)\nM:	([^\n]+)\n@M:	\1 <\2>\n@g; print; }' MAINTAINERS
#
# Quote names with periods, commas and parentheses
#
sed -r -i -e "s/^M:	(.+)([\.,'\(])(.*) </M:	\"\1\2\3\" </g" MAINTAINERS
#
# Add a description of email name style
#
patch -p1 <<EOF
diff --git a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -73,8 +73,8 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person
-M: Mail patches to
+P: Person (obsolete)
+M: Mail patches to: FullName <address@domain>
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
EOF

--=-uhZgQI1RIN04AuTa62Nv--

