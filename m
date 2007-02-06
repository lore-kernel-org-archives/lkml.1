Return-Path: <linux-kernel-owner+w=401wt.eu-S965134AbXBFQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134AbXBFQku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965140AbXBFQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:40:50 -0500
Received: from raven.upol.cz ([158.194.120.4]:32782 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbXBFQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:40:49 -0500
Date: Tue, 6 Feb 2007 17:47:52 +0100
To: Mark Lord <lkml@rtr.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       William Stearns <wstearns@pobox.com>,
       Martin Schlemmer <azarah@nosferatu.za.org>
Subject: Re: [patch 1/3, resend] scripts: replace gawk, head, bc with shell, update
Message-ID: <20070206164752.GB1160@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.805083000@flower.upol.cz> <45C8958B.8040906@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C8958B.8040906@rtr.ca>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:49:47AM -0500, Mark Lord wrote:
> Oleg Verych wrote:
> >scripts: replace gawk, head, bc with shell, update
> >
> >  Replacing overhead of using some (external) programs
> >  instead of good old `sh'.
> ...                                  <---------------,
> >-    t4=`echo $t3 | gawk '{ print $1 }'`            |
> >-    t5=`echo $t1 | gawk '{ print $1 }'`            |
> >-    t6=`echo $t4 - $t5 | tr a-f A-F`               |
> >-    t7=`( echo  ibase=16 ; echo $t6 ) | bc`        |
> >+    t4=`field 1 $t3`                               |
> >+    t5=`field 1 $t1`                               |
> >+    t6=`printf "%lu" $((0x$t4 - 0x$t5))`           |
> ...                                                  |
>                                                      |
> >From where do we obtain this new "field" command ?  |
                                       `---- here -----'

Without jokes, it even commented:

+# awk style field access
+field() {
+  shift $1 ; echo $1
+}
+

> Cheers
____
