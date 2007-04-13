Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXDMJaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXDMJaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXDMJaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:30:01 -0400
Received: from smtp112.plus.mail.re2.yahoo.com ([206.190.53.37]:35846 "HELO
	smtp112.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753289AbXDMJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:30:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
  b=ip3TDlGa3P2rlwfrNX0Asbs4hWTyhRGs3BB27Fmvvj8E7gE7GbfEYtYcCmZuExpT8ThmByr1ICHB2tVNOh7bJqa5UHDxS1tuvZneNEaxbLfP2Ldz5C53n80Wk1zZrp7nO7HbxYNuHFHdOlDtufmrsA8bCgC7WLDdGJ3mqIvsgsk=  ;
X-YMail-OSG: elGnRLYVM1lsiOssXLr39s9d7zLXuG9izAyLxm0SkLUkwBgG
Date: Fri, 13 Apr 2007 11:29:43 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070413092943.GA16491@zmei.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413091422.GA15426@zmei.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the improper whitespaces, here's a correct version.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>


Index: 21-rc6/scripts/kernel-doc
===================================================================
--- 21-rc6.orig/scripts/kernel-doc
+++ 21-rc6/scripts/kernel-doc
@@ -326,6 +326,32 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# get kernel version
+sub get_kernel_version() {
+    my $version;
+    open (FILE, "../Makefile") || die "Can't open man kernel Makefile: $!";
+
+    EOF: while (my $line = <FILE>)
+    {
+	if ($line =~ /VERSION\s+=\s+(\d+)/) {
+	     $version .= $1;
+	     next;
+	}
+	if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
+	     $version .= ".$1";
+	     next;
+	}
+	if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
+	     $version .= ".$1";
+	     next;
+	}
+	if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
+	     $version .= $1;
+	     last EOF;
+	}
+    }
+    return $version;
+}
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -592,6 +618,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -668,6 +695,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -752,6 +780,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
