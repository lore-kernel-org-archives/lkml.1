Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZF3Uis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZF3Uis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZF3Uil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:38:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbZF3Uik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:38:40 -0400
Date: Tue, 30 Jun 2009 13:38:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
Message-Id: <20090630133816.f62b0cb4.akpm@linux-foundation.org>
In-Reply-To: <56465.1246393621@turing-police.cc.vt.edu>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
	<54770.1246392952@turing-police.cc.vt.edu>
	<56465.1246393621@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 16:27:01 -0400
Valdis.Kletnieks@vt.edu wrote:

> Not sure why that line did it.  Repeated truncate-and-try shows that if the
> line contained just the 4 chars '0804', it applied fine, but '0804a' dies.

That's patch(1) thinking it's a regular diff:

akpm:/usr/src/25> diff Makefile Makefile~linux-next
4c4
< EXTRAVERSION = -rc1-mm1
---
> EXTRAVERSION = -rc1
142a143,144
> TOPDIR                := $(srctree)
> # FIXME - TOPDIR is obsolete, use srctree/objtree
149c151
< export srctree objtree VPATH
---
> export srctree objtree VPATH TOPDIR
328c330
< LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
---
> LDFLAGS_MODULE  =
345,346c347
<                  -Werror-implicit-function-declaration \
<                  -Wno-format-security
---
>                  -Werror-implicit-function-declaration


So the "0804a" means "at line 804, start appending stuff", or something
like that.

Use -u.
