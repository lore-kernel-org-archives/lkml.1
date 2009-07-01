Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZGASiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZGASiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZGASiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:38:21 -0400
Received: from kroah.org ([198.145.64.141]:46767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZGASiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:38:20 -0400
Date: Wed, 1 Jul 2009 11:38:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Gilles Espinasse <g.esp@free.fr>
Subject: [patch 32/30] kbuild: fix C libary confusion in unifdef.c due to
 getline()
Message-ID: <20090701183812.GC14064@kroah.com>
References: <20090701002817.GA6156@kroah.com>
 <20090701183548.GA14064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701183548.GA14064@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch

-------------------------

From: Justin P. Mattock <justinmattock@gmail.com>

commit d15bd1067b1fcb2b7250d22bc0c7c7fea0b759f7 upstream.

This fixes an error when compiling the kernel.

  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
make[1]: *** [scripts/unifdef] Error 1
make: *** [__headers] Error 2

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc:  Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilles Espinasse <g.esp@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/unifdef.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)
 
 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = get_line();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+get_line(void)
 {
 	const char *cp;
 	int cursym;
