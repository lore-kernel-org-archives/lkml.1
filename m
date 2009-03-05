Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZCEFlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZCEFlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 00:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZCEFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 00:41:13 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:41765 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZCEFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 00:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kP0OtX8gCGX16SwVvqHjrwNs1Y8gqvOzzmX84HGVIxZhHxcKKV0Da/OtBuHPYJRfVS
         aKnqN1HH5B93kYF237eKkVNaG6Qx6kCejqHmpkGRZoFcGc6IvKLCNqaoHko5WCG5qF9h
         J+oDrVCEefuGjlSTxU0GrWeaEHOm+3oCsa3gg=
MIME-Version: 1.0
Date: Wed, 4 Mar 2009 21:41:09 -0800
Message-ID: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
Subject: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid C 
	library confusion.
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin P. Mattock <justinmattock@gmail.com>

This fixes an error when compiling the kernel.

  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
make[1]: *** [scripts/unifdef] Error 1
make: *** [__headers] Error 2

--
scripts/unifdef.c  |  3 +++
1 files changed, 3 insertions(+),0 deletions(-)

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
---a/scripts/unifdef.c
+++b/scripts/unifdef.c
@@ -203,1 +203,0 @@ static void             addsym(bool, bool, char *);


static void             done(void);
static void             error(const char *);
static int              findsym(const char *);
static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
static Linetype         ifeval(const char **);
static void             ignoreoff(void);
static void             ignoreon(void);
static void             keywordedit(const char *);




@@ -509,1 +509,0 @@ process(void)


{
	Linetype lineval;

	for (;;) {
		linenum++;
-               lineval = getline();
+		lineval = get_line();
		trans_table[ifstate[depth]][lineval]();
		debug("process %s -> %s depth %d",
		    linetype_name[lineval],
		    ifstate_name[ifstate[depth]], depth);
	}
}


@@ -528,1 +528,0 @@ static Linetype
-getline(void)
+get_line(void)
{
	const char *cp;

--


keep in mind I've never created a patch before,
(so go easy on me);

regards;

-- 
Justin P. Mattock
