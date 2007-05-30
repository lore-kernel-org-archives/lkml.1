Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXE3ENR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXE3ENR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXE3ENG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:13:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10963 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXE3ENE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:13:04 -0400
Date: Tue, 29 May 2007 21:18:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch] tweak make htmldocs (nochunks and better index).
Message-Id: <20070529211809.d995a5f7.randy.dunlap@oracle.com>
In-Reply-To: <200705291528.34092.rob@landley.net>
References: <200705291528.34092.rob@landley.net>
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

On Tue, 29 May 2007 15:28:33 -0400 Rob Landley wrote:

> Signed-off-by: Rob Landley <rob@landley.net>
> 
> A) The "xmtml-nochunks" version of "make htmldocs" is easier to print.
> 
> B) Update the generated index.html to use the html <title> as a
>    description for each file it links to.
> 
> --
> 
> --- git/Documentation/DocBook/Makefile	2007-05-23 16:36:56.000000000 -0400
> +++ work/Documentation/DocBook/Makefile	2007-05-26 23:11:36.000000000 -0400
> @@ -141,9 +141,12 @@
>  		   cat $(HTML) >> $(main_idx)
>  
>  quiet_cmd_db2html = HTML   $@
> -      cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
> -		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
> -        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
> +      cmd_db2html = xmlto xhtml-nochunks $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
> +		NAME='$(patsubst %.html,%,$(notdir $@))'; \
> +		echo -n "<p><a HREF=\"$$NAME/$$NAME.html\">$$NAME</a>" > $@ ; \
> +		sed -nre 's@.*<title>(.*)</title>.*@\1@p' \
> +			"Documentation/DocBook/$$NAME/$$NAME.html" >> $@ ; \
> +		echo '<\p>' >> $@
>  
>  %.html:	%.xml
>  	@(which xmlto > /dev/null 2>&1) || \
> -

What is <\p> supposed to do?

Here's what I see in index.html (beginning lines of it):

Linux Kernel HTML Documentation
Kernel Version: 2.6.22-rc3

deviceiobookBus-Independent Device Accesses <\p>

filesystemsLinux Filesystems API <\p>

gadgetUSB Gadget API for Linux <\p>

genericirqLinux generic IRQ handling <\p>

kernel-apiThe Linux Kernel API <\p>

kernel-hackingUnreliable Guide To Hacking The Linux Kernel <\p>

kernel-lockingUnreliable Guide To Locking <\p> 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
