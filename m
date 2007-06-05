Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbXFEN1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbXFEN1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbXFEN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:26:55 -0400
Received: from raven.upol.cz ([158.194.120.4]:41808 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbXFEN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:26:54 -0400
Date: Tue, 5 Jun 2007 15:38:34 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605133834.GO7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605081959.GB21991@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:19:59AM +0200, Sam Ravnborg wrote:
[]
> If on the other hand you are proposing a script to clean whitespace
> damage in the code then git already does this nicely.

I've read that too quickly, sorry. What then all that clean scripts
are for?

> I do not recall the actual receipt but searching the git mailing list
> should reveal it. So for whitespace cleanup we should use git but maybe
> via a small helper script.

So, just to protect script from itself or similar one, here's update
(only for those, who's interested, of course).

-*- clean-whitespace.sh -*-
#!/bin/sh -e
# stdin/stdout

IFS=''
t="`printf '\t'`" ; s=' ' ; s7='       ' ; w79=79 ;
case $0 in *diff* | *patch*) p='+' ; s='';; esac

while read line
do case "$line" in
   ++*) echo "$line";;
   $p*) line="`echo \"$line\" | expand`"
	[ ${#line} -gt $w79 ] && : ${long:=line}
	echo "$line" | sed "/^$p/{s_ *\$__;s_^$p$s7${s}_$p${t}_;s_$s7 _${t}_g}"
	;;
     *) echo "$line";;
   esac
done
[ -n "$long" ] && echo "at least one line, wider than $w79 chars, found" 1>&2

-*-
