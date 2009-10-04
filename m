Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZJDBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZJDBN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZJDBN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 21:13:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1629 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZJDBN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 21:13:26 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add WARN on sizeof(&
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Jan Ceuleers <jan.ceuleers@computer.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC77003.9090805@computer.org>
References: <20091002113038.1dc3d284@hyperion.delvare>
	 <20091002.095402.42770342.davem@davemloft.net>
	 <4AC77003.9090805@computer.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Oct 2009 18:12:49 -0700
Message-Id: <1254618769.1799.280.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 17:38 +0200, Jan Ceuleers wrote:
> David Miller wrote:
> > Any time you see "&" in a sizeof() expression, it's almost
> > certainly a bug.  Something for the folks with automated
> > tools to look for if they haven't already :-)
> 
> Your remark prompted me to find four more instances of such bugs
> (none of which in the networking bits). I have submitted patches.

Perhaps a checkpatch test.

---

sizeof(&foo) is frequently an error.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..596dd72 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2534,6 +2534,11 @@ sub process {
 			WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
 
+# check for sizeof(&)
+		if ($line =~ /\bsizeof\s*\(\s*\&/) {
+			WARN("sizeof(& should be avoided\n" . $herecurr);
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)


