Return-Path: <linux-kernel-owner+w=401wt.eu-S2992878AbXDRROy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992878AbXDRROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992883AbXDRROy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:14:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16808 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992878AbXDRROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:14:53 -0400
Date: Wed, 18 Apr 2007 10:16:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070418101654.7c7906c1.randy.dunlap@oracle.com>
In-Reply-To: <20070413092943.GA16491@zmei.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070413092943.GA16491@zmei.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:29:43 +0200 Borislav Petkov wrote:

> Sorry for the improper whitespaces, here's a correct version.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> 
> Index: 21-rc6/scripts/kernel-doc
> ===================================================================
> --- 21-rc6.orig/scripts/kernel-doc
> +++ 21-rc6/scripts/kernel-doc
> @@ -326,6 +326,32 @@ while ($ARGV[0] =~ m/^-(.*)/) {
>      }
>  }
>  
> +# get kernel version
> +sub get_kernel_version() {
> +    my $version;
> +    open (FILE, "../Makefile") || die "Can't open man kernel Makefile: $!";

How are you running scripts/kernel-doc ?
I had to change "../Makefile" to just "Makefile" when using
'make htmldocs;.

> +    EOF: while (my $line = <FILE>)
> +    {
> +	if ($line =~ /VERSION\s+=\s+(\d+)/) {
> +	     $version .= $1;
> +	     next;
> +	}
> +	if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
> +	     $version .= ".$1";
> +	     next;
> +	}
> +	if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
> +	     $version .= ".$1";
> +	     next;
> +	}
> +	if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
> +	     $version .= $1;
> +	     last EOF;
> +	}
> +    }
> +    return $version;
> +}
>  
>  # generate a sequence of code that will splice in highlighting information
>  # using the s// operator.
> @@ -592,6 +618,7 @@ sub output_function_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>".$args{'function'}."</refname>\n";
> @@ -668,6 +695,7 @@ sub output_struct_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
> @@ -752,6 +780,7 @@ sub output_enum_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>enum ".$args{'enum'}."</refname>\n";
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
