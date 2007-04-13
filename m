Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXDMVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXDMVBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030278AbXDMVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:01:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41138 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbXDMVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:01:18 -0400
Date: Fri, 13 Apr 2007 14:03:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: make clean for DocBook
Message-Id: <20070413140337.9ecba871.randy.dunlap@oracle.com>
In-Reply-To: <20070413193250.GA15361@uranus.ravnborg.org>
References: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com>
	<20070413164142.GA14706@uranus.ravnborg.org>
	<20070413112316.44141d34.randy.dunlap@oracle.com>
	<20070413193250.GA15361@uranus.ravnborg.org>
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

On Fri, 13 Apr 2007 21:32:50 +0200 Sam Ravnborg wrote:

> > > 
> > > 
> > > And we will visit DocBook with mrproper - but not clean.
> > > I have no stron opinion when to delete generated files in DocBook.
> > 
> > OK, that's fine, thanks for the info...
> > but trying 'make mrproper' gives me:
> > 
> > make -f scripts/Makefile.clean obj=Documentation/DocBook
> > make -f scripts/Makefile.clean obj=Documentation/DocBook/man/
> > make[2]: execvp: /bin/sh: Argument list too long
> > make[2]: *** [__clean] Error 127
> > make[1]: *** [Documentation/DocBook/man/] Error 2
> > make: *** [_mrproper_Documentation/DocBook] Error 2
> > 
> > DocBook/man/ contains about 2000 files.
> > Is there some way to have scripts/Makefile.clean just do
> > 	rm -rf Documentation/DocBook/man/
> > ?  or some other solution?
> 
> Something like this should do it.
> This deletes the man/ directory entirely so
> I have to do that when I check in the patch.
> 
> Let me know if this works for you.

Yes, thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> 	Sam
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 867608a..960f402 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -152,6 +152,7 @@ quiet_cmd_db2man = MAN     $@
>  	@(which xmlto > /dev/null 2>&1) || \
>  	 (echo "*** You need to install xmlto ***"; \
>  	  exit 1)
> +	$(Q)mkdir -p $(obj)/man
>  	$(call cmd,db2man)
>  	@touch $@
>  
> @@ -212,11 +213,7 @@ clean-files := $(DOCBOOKS) \
>  	$(patsubst %.xml, %.9,    $(DOCBOOKS)) \
>  	$(C-procfs-example)
>  
> -clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS))
> -
> -#man put files in man subdir - traverse down
> -subdir- := man/
> -
> +clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
>  
>  # Declare the contents of the .PHONY variable as phony.  We keep that
>  # information in a variable se we can use it in if_changed and friends.
> diff --git a/Documentation/DocBook/man/Makefile b/Documentation/DocBook/man/Makefile
> deleted file mode 100644
> index 4fb7ea0..0000000
> --- a/Documentation/DocBook/man/Makefile
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -# Rules are put in Documentation/DocBook
> -
> -clean-files := *.9.gz *.sgml manpage.links manpage.refs
> 
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
