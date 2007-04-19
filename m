Return-Path: <linux-kernel-owner+w=401wt.eu-S1031181AbXDSGhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031181AbXDSGhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031161AbXDSGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:37:07 -0400
Received: from smtp103.plus.mail.mud.yahoo.com ([68.142.206.236]:21249 "HELO
	smtp103.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031154AbXDSGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:37:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=ifw2k8zA7XXJgppesfQGr1KTKgmexGZ92tLt18Br6Y0i5Ea4COoK+gz5yRoIucegfvH4Qy6aHYqPsQbqzvMPxPvZioMuSrewiK2rS/TQ9cAkDUMvDWfLquEU11y/gnmxJrc665mJE268qNRmbTOZX8ptwz41LkvvQ0oeFp+9pAc=  ;
X-YMail-OSG: 2n67TgEVM1mhRrRFGS7QIBpiXxnU1uGPIAJ17JpcW9kBNXgAggHJrbw4Ol7Cs4puktaCx5E58A--
Date: Thu, 19 Apr 2007 08:30:19 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070419063019.GB3974@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070413092943.GA16491@zmei.tnic> <20070418101654.7c7906c1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070418101654.7c7906c1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 10:16:54AM -0700, Randy Dunlap wrote:
> On Fri, 13 Apr 2007 11:29:43 +0200 Borislav Petkov wrote:
> 
> > Sorry for the improper whitespaces, here's a correct version.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > 
> > 
> > Index: 21-rc6/scripts/kernel-doc
> > ===================================================================
> > --- 21-rc6.orig/scripts/kernel-doc
> > +++ 21-rc6/scripts/kernel-doc
> > @@ -326,6 +326,32 @@ while ($ARGV[0] =~ m/^-(.*)/) {
> >      }
> >  }
> >  
> > +# get kernel version
> > +sub get_kernel_version() {
> > +    my $version;
> > +    open (FILE, "../Makefile") || die "Can't open man kernel Makefile: $!";
> 
> How are you running scripts/kernel-doc ?
> I had to change "../Makefile" to just "Makefile" when using
> 'make htmldocs;.
I knew this one would come around and bite me in the a**. My cmd is :
make V=1 O=build/  htmldocs > build.log 2>&1

so man is cd-ing into the O=build directory and then the main Makefile is one
level above it. Gonna fix this properly today and get back to you.
> 
> > +    EOF: while (my $line = <FILE>)
> > +    {
> > +	if ($line =~ /VERSION\s+=\s+(\d+)/) {
> > +	     $version .= $1;
> > +	     next;
> > +	}
> > +	if ($line =~ /PATCHLEVEL\s+=\s+(\d+)/) {
> > +	     $version .= ".$1";
> > +	     next;
> > +	}
> > +	if ($line =~ /SUBLEVEL\s+=\s+(\d+)/) {
> > +	     $version .= ".$1";
> > +	     next;
> > +	}
> > +	if ($line =~ /EXTRAVERSION\s+=\s+(.*)$/) {
> > +	     $version .= $1;
> > +	     last EOF;
> > +	}
> > +    }
> > +    return $version;
> > +}
> >  
> >  # generate a sequence of code that will splice in highlighting information
> >  # using the s// operator.
> > @@ -592,6 +618,7 @@ sub output_function_xml(%) {
> >      print "<refmeta>\n";
> >      print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
> >      print " <manvolnum>9</manvolnum>\n";
> > +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
> >      print "</refmeta>\n";
> >      print "<refnamediv>\n";
> >      print " <refname>".$args{'function'}."</refname>\n";
> > @@ -668,6 +695,7 @@ sub output_struct_xml(%) {
> >      print "<refmeta>\n";
> >      print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
> >      print " <manvolnum>9</manvolnum>\n";
> > +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
> >      print "</refmeta>\n";
> >      print "<refnamediv>\n";
> >      print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
> > @@ -752,6 +780,7 @@ sub output_enum_xml(%) {
> >      print "<refmeta>\n";
> >      print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
> >      print " <manvolnum>9</manvolnum>\n";
> > +    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
> >      print "</refmeta>\n";
> >      print "<refnamediv>\n";
> >      print " <refname>enum ".$args{'enum'}."</refname>\n";
> > -
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
Regards/Gruﬂ,
    Boris.
