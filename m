Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXDTF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXDTF7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422919AbXDTF7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:59:34 -0400
Received: from smtp111.plus.mail.re2.yahoo.com ([206.190.53.36]:24880 "HELO
	smtp111.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422651AbXDTF7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:59:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=q12xwIOzULJVb/eXSZrivtAvJyeI7Iwl+DZTaiT67Rg+IoB67ipigZEfOXJj+tRhdx/GF63+CxxqrQcGazjI4IOpWR5QgpofYYi1+GlFBHvPv8Wj8KCAdaUxEjI/tniet6iIjL6MIUmp3kLKImXeI6Lui7nTieAcx9RIzBO+cbY=  ;
X-YMail-OSG: jCw.TsEVM1lJNqQzOslh3v9htfVcfhDuS3XZa6iy1xWqqycEEBMlKvSiGYt_EefJPU3AThX4nPE5nZzU3UxBOZtFHw--
Date: Fri, 20 Apr 2007 07:59:25 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070420055925.GA3967@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070413092943.GA16491@zmei.tnic> <20070418101654.7c7906c1.randy.dunlap@oracle.com> <20070419063019.GB3974@gollum.tnic> <20070419071931.GA4778@gollum.tnic> <20070419092122.51b59719.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070419092122.51b59719.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:21:22AM -0700, Randy Dunlap wrote:
> On Thu, 19 Apr 2007 09:19:32 +0200 Borislav Petkov wrote:
> 
> > A fixed version of the patch shutting up missing version warnings when building
> > mandocs.
> 
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt ::
> Please include a full patch description/changelog in the future.
will do

> > +sub get_kernel_version() {
> > +    my $version;
> > +    open (FILE, $ENV{"SRCTREE"}."Makefile") || die "Can't open main kernel Makefile: $!";
> 
> This needs to handle the environment variable not
> being there, as another location in scripts/kernel-doc does.
> Updated patch below.  Is this OK with you?
yep, this one is fine.

> -----
> 
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> This patch shuts warnings of the sort:
> 
> make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
> 	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
> 	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
> make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
> make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
>   SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
>   if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
> Note: meta version: No productnumber or alternative     sppp_close
> Note: meta version: No refmiscinfo@class=version        sppp_close
> Note: Writing sppp_close.9
> Note: meta version: No productnumber or alternative     sppp_open
> Note: meta version: No refmiscinfo@class=version        sppp_open
> 
> by adding a RefMiscInfo xml tag in the form of the current kernel version to 
> the function, struct and enum definitions in files included by kernel-doc when 
> building 'mandocs'.  However, the version string appears truncated on the manpage
> due to some constraints in the xml DTD for the man header, I believe, for the
> troff output is truncated too.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> 
>  scripts/kernel-doc |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> --- linux-2621-rc7.orig/scripts/kernel-doc
> +++ linux-2621-rc7/scripts/kernel-doc
> @@ -326,6 +326,39 @@ while ($ARGV[0] =~ m/^-(.*)/) {
>      }
>  }
>  
> +# get kernel version
> +sub get_kernel_version() {
> +    my $version;
> +    my $mkfile;
> +    if (defined($ENV{'srctree'})) {
> +	$mkfile = "$ENV{'srctree'}" . "/Makefile";
> +    }
> +    else {
> +	$mkfile = "Makefile";
> +    }
> +    open (FILE, "$mkfile") || die "Can't open main kernel Makefile: $!";
> +
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
> @@ -592,6 +625,7 @@ sub output_function_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>".$args{'function'}."</refname>\n";
> @@ -668,6 +702,7 @@ sub output_struct_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
> @@ -752,6 +787,7 @@ sub output_enum_xml(%) {
>      print "<refmeta>\n";
>      print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
>      print " <manvolnum>9</manvolnum>\n";
> +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
>      print "</refmeta>\n";
>      print "<refnamediv>\n";
>      print " <refname>enum ".$args{'enum'}."</refname>\n";

-- 
Regards/Gruﬂ,
    Boris.
