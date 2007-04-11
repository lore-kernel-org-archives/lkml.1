Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXDKETX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXDKETX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXDKETX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:19:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49075 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162AbXDKETU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:19:20 -0400
Date: Tue, 10 Apr 2007 21:21:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] generate main index page when building
 'htmldocs'
Message-Id: <20070410212143.3a5d786d.randy.dunlap@oracle.com>
In-Reply-To: <20070410234422.GA30554@zmei.tnic>
References: <20070410234422.GA30554@zmei.tnic>
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

On Wed, 11 Apr 2007 01:44:22 +0200 Borislav Petkov wrote:

> Here's a patch for kernel-doc that enables the generation of a global, TOC-like index.html 
> page after building 'htmldocs'
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Nice idea.  However, the order of entries in index.html is suboptimal,
due to the order of DOCBOOKS in the Makefile.  You could submit a patch
for that, or I'll change it.

Thanks.


> Index: 21-rc6/Documentation/DocBook/Makefile
> ===================================================================
> --- 21-rc6.orig/Documentation/DocBook/Makefile	2007-04-11 00:02:02.000000000 +0200
> +++ 21-rc6/Documentation/DocBook/Makefile	2007-04-11 01:00:21.000000000 +0200
> @@ -44,6 +44,7 @@
>  
>  HTML := $(patsubst %.xml, %.html, $(BOOKS))
>  htmldocs: $(HTML)
> +	$(call build_main_index)
>  
>  MAN := $(patsubst %.xml, %.9, $(BOOKS))
>  mandocs: $(MAN)
> @@ -133,10 +134,17 @@
>  %.pdf : %.xml
>  	$(call cmd,db2pdf)
>  
> +
> +main_idx = Documentation/DocBook/index.html
> +build_main_index = rm -rf $(main_idx) && \
> +		   echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
> +		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
> +		   cat $(HTML) >> $(main_idx)
> +
>  quiet_cmd_db2html = HTML   $@
>        cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
>  		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
> -         Goto $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
> +        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
>  
>  %.html:	%.xml
>  	@(which xmlto > /dev/null 2>&1) || \
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
