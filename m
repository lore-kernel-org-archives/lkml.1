Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXDOHK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXDOHK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 03:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXDOHK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 03:10:57 -0400
Received: from smtp106.plus.mail.re2.yahoo.com ([206.190.53.31]:40971 "HELO
	smtp106.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751143AbXDOHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 03:10:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Jk+MZcYzwnkGSFPm79DuRP1YLaO3zKxS6I2/KsnfyrMK8azsJncbyvOmwacHAneoBAVv721xN8J7hwtGopXi5r0qiNnbfFIIZHc3LU904Zz+m4Kv8/m0RQ2FaIl0Z5fzT+gA0v/sqIfADYzmcmsG6SyQYexvAq2uxuLLYonSwNg=  ;
X-YMail-OSG: ppe2HnYVM1lXQn.4.lV8iP.YSPjEAWnAioeZVLeWUWWYAF0R3bXj0U3T1UQ9.sJVMBSam_uv.NM5CdGVVWGlDdQK03MblUWVLIbNVFtklafMnogywVo-
Date: Sun, 15 Apr 2007 09:10:50 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070415071050.GA4002@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070414091341.7665d8b0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070414091341.7665d8b0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 09:13:41AM -0700, Randy Dunlap wrote:
> On Fri, 13 Apr 2007 11:14:22 +0200 Borislav Petkov wrote:
> 
> > This patch shuts warnings of the sort:
> > 
> > make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
> > 	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
> > 	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
> > make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
> > make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
> >   SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
> >   if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
> > Note: meta version: No productnumber or alternative     sppp_close
> > Note: meta version: No refmiscinfo@class=version        sppp_close
> > Note: Writing sppp_close.9
> > Note: meta version: No productnumber or alternative     sppp_open
> > Note: meta version: No refmiscinfo@class=version        sppp_open
> > 
> > by adding a RefMiscInfo xml tag in the form of the current kernel version to 
> > the function, struct and enum definitions in files included by kernel-doc when 
> > building 'mandocs'.  However, the version string appears truncated on the manpage
> > due to some constraints in the xml DTD for the man header, I believe, for the
> > troff output is truncated too.
> 
> Hi Borislav,
> 
> I cannot reproduce this error (either, a la the tex error).
> Any hints about how I could do so?

Hm, this is strange. IIRC, the refmiscinfo version tag is imposed by the docbook
xsl stylesheets for manpages, see
http://www.oasis-open.org/archives/docbook-apps/200508/msg00111.html and
especially the 'man'-section, subsection 'extra2 field.' According to it, 
the stylesheets check several different locations for version info to be put in
the left footer position in the manpage, and if none is found, they simply state
that there's no version info, so this is not an error message but simply a
notification which, if nothing else, annoys while building the mandocs.

The URL cites the changelog of docbook-xsl 1.69.1 and this is also the
version in SLED 10 you're using so you should be getting this, too. I'll
try to dig deeper into this. The relevant packs I use are docbook-xsl:
1.72.0.dfsg.1-1, xmlto: 0.0.18-5.1 on debian unstable. 

-- 
Regards/Gruﬂ, 
Boris.
