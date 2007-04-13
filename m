Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbXDMSVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbXDMSVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDMSVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:21:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23578 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXDMSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:21:15 -0400
Date: Fri, 13 Apr 2007 11:23:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: make clean for DocBook
Message-Id: <20070413112316.44141d34.randy.dunlap@oracle.com>
In-Reply-To: <20070413164142.GA14706@uranus.ravnborg.org>
References: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com>
	<20070413164142.GA14706@uranus.ravnborg.org>
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

On Fri, 13 Apr 2007 18:41:42 +0200 Sam Ravnborg wrote:

> On Fri, Apr 13, 2007 at 09:06:58AM -0700, Randy Dunlap wrote:
> > Hi Sam,
> > 
> > 'make clean' doesn't seem to descend into Documentation/DocBook/.
> > At least 'make V=1 clean' doesn't show me any references in DocBook.
> > 
> > I guess that this is because DocBook doesn't have anything that
> > qualifies in obj-y/m/n and subdir-y/m/n.  (?)
> 
> Documentation/ is handled explicit i top-level Makefile:
> 
> mrproper-dirs      := $(addprefix _mrproper_,Documentation/DocBook scripts)
> 
> PHONY += $(mrproper-dirs) mrproper archmrproper
> $(mrproper-dirs):
>         $(Q)$(MAKE) $(clean)=$(patsubst _mrproper_%,%,$@)
> 
> 
> And we will visit DocBook with mrproper - but not clean.
> I have no stron opinion when to delete generated files in DocBook.

OK, that's fine, thanks for the info...
but trying 'make mrproper' gives me:

make -f scripts/Makefile.clean obj=Documentation/DocBook
make -f scripts/Makefile.clean obj=Documentation/DocBook/man/
make[2]: execvp: /bin/sh: Argument list too long
make[2]: *** [__clean] Error 127
make[1]: *** [Documentation/DocBook/man/] Error 2
make: *** [_mrproper_Documentation/DocBook] Error 2

DocBook/man/ contains about 2000 files.
Is there some way to have scripts/Makefile.clean just do
	rm -rf Documentation/DocBook/man/
?  or some other solution?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
