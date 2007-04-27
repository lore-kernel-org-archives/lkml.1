Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbXD0VJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbXD0VJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXD0VJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:09:01 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:47948 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbXD0VI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:08:59 -0400
Message-ID: <463265D4.1010703@gmail.com>
Date: Fri, 27 Apr 2007 23:06:28 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <462C7D74.60003@gmail.com> <1177327476.17026.75.camel@localhost.localdomain> <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain> <462CA764.5080401@gmail.com> <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de> <20070426084143.1d973c71.randy.dunlap@oracle.com> <20070426155205.GN3468@stusta.de> <4631219D.4060402@gmail.com>
In-Reply-To: <4631219D.4060402@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050403080804060905020108"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050403080804060905020108
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/27/2007 12:03 AM, Rene Herman wrote:

> With the point you make about old installed kernel modules having 
> outdated information forever you've in fact convinced me that 
> MODULE_MAINTAINER is not a good idea.

[ ... ]

> Deleting the email addresses from the MODULE_AUTHOR tag would go some 
> ways to fix it; it's then at least clearer that the author is not being 
> displayed as a general contact for the driver. It may on the other hand 
> want to remain as a legal contact and I only know of "modinfo" as a 
> normal way of listing the tags, so even a very minimal solution such as 
> having modinfo supress the author tag, or even just any email address in
> it, would be good enough.

Ie, something like the attached minimal patch to modinfo that just supresses 
the author= tag from the default output; the information is still available 
from modinfo -a.

However. Looking at the MODULE_AUTHOR tags in the tree:

rene@7ixe4:~/src/linux/local$ grep -r MODULE_AUTHOR * | wc -l
2211

more than half of them already don't provide an email address:

rene@7ixe4:~/src/linux/local$ grep -r "MODULE_AUTHOR(.*<.*>.*)" * | wc -l
1088

Alan is one of the people using just MODULE_AUTHOR("Alan Cox") without an 
address. Given that the email address is all that I want to supress; how 
about just deleting that instead?

I'd prefer that; unlike the name, the adress is information that can get 
outdated and moreover, removing the address not only from the modinfo output 
but from the source directly means it can't be mistaken for a contact 
address there either.

Comments? Objections? If none, I'll start submitting patches removing email 
addresses from the MODULE_AUTHOR tags in the tree.

Rene.


--------------050403080804060905020108
Content-Type: text/plain;
 name="modinfo_author.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modinfo_author.diff"

--- module-init-tools-3.3-pre1/modinfo.c.orig	2007-04-04 12:54:19.000000000 +0200
+++ module-init-tools-3.3-pre1/modinfo.c	2007-04-27 22:41:54.000000000 +0200
@@ -167,6 +167,9 @@
 	for (; info; info = next_string(info, &size)) {
 		char *eq, *colon;
 
+		if (strstarts(info, "author="))
+			continue;
+
 		/* We expect this in parm and parmtype. */
 		colon = strchr(info, ':');
 

--------------050403080804060905020108--
