Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZI3JU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZI3JU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZI3JU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:20:26 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43138 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZI3JUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:20:25 -0400
Date: Wed, 30 Sep 2009 11:20:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
 Makefiles?
Message-ID: <20090930112023.4fbb3da0@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1254297299.2960.55.camel@Joe-Laptop.home>
References: <1254248104.28232.447.camel@Joe-Laptop.home>
	<20090930065533.GB13850@merkur.ravnborg.org>
	<1254297299.2960.55.camel@Joe-Laptop.home>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 00:54:59 -0700
Joe Perches <joe@perches.com> wrote:

> If something like were added to a module Makefile:
> 
> 	ccflags-y += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"

That would define a pr_fmt macro for ALL source files. That would add
the prefix to every single pr_xxx printk. That a) changes the text of
these printk and b) makes printks that already have a different prefix
look very funny. The point is that you need to adapt you source file in
order to use the pr_fmt prefix mechanis, no automatic conversion is
possible.

> or if necessary a per-file entry in the Makefile:
> 
> 	CFLAGS_foo.o += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"

Where is the difference between the definition of the macro in the
source file? It's still one additional line, no? And if you are
dreaming of converting all source files to the pr_fmt mechanism, this
is a big effort ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

