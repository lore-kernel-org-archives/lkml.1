Return-Path: <linux-kernel-owner+w=401wt.eu-S2993132AbXDSHTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993132AbXDSHTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993156AbXDSHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:19:38 -0400
Received: from smtp110.plus.mail.re2.yahoo.com ([206.190.53.35]:45886 "HELO
	smtp110.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993132AbXDSHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:19:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=GofDK6C4+pU5cuoiRxqDFCxP85MF4qkti22p8N3iebSQX0qdqsonMt1T8saWZzSwIR3JA3BSgozC9NODGAyl7cCMpmnh1icShD3nUdSMP66lt+ioMjTJUIIKrZdMoWK4xxClKzDAT6spovYgwsRckA3BQ5OlY/TldtJbEFGnEjU=  ;
X-YMail-OSG: AgCEnzUVM1m8IFW1pAwO.qFpJ8KaY7_qDTMcyffP_U6BNc1Z7zmxLjd20a18R_8tNLkYVG1w_Q--
Date: Thu, 19 Apr 2007 09:19:32 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070419071931.GA4778@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070413092943.GA16491@zmei.tnic> <20070418101654.7c7906c1.randy.dunlap@oracle.com> <20070419063019.GB3974@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070419063019.GB3974@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A fixed version of the patch shutting up missing version warnings when building
mandocs.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>


Index: 21-rc7/scripts/kernel-doc
===================================================================
--- 21-rc7.orig/scripts/kernel-doc
+++ 21-rc7/scripts/kernel-doc
@@ -326,6 +326,32 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# get kernel version
+sub get_kernel_version() {
+    my $version;
+    open (FILE, $ENV{"SRCTREE"}."Makefile") || die "Can't open main kernel Makefile: $!";
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

-- 
Regards/Gruﬂ,
    Boris.
