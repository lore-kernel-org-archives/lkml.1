Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXCHDsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXCHDsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXCHDsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:48:13 -0500
Received: from raven.upol.cz ([158.194.120.4]:62454 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXCHDsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:48:12 -0500
To: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com
Cc: Jean Delvare <khali@linux-fr.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: trailing whitespace killing (Re: [PATCH -mm] Blackfin: blackfin i2c driver)
In-Reply-To: <20070306234529.3ce4cf3b.akpm@linux-foundation.org>
References: <1173164058.31825.16.camel@roc-desktop> <20070306214301.GA5590@martell.zuzino.mipt.ru> <1173247078.28531.24.camel@roc-desktop> <20070307075822.53e53c42.khali@linux-fr.org> <20070306231423.4231c99b.akpm@linux-foundation.org> <1173253167.28531.41.camel@roc-desktop> <20070306234529.3ce4cf3b.akpm@linux-foundation.org>
Date: Thu, 8 Mar 2007 04:57:29 +0100
Message-Id: <E1HP9kv-0002tC-RS@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
> Date: Tue, 6 Mar 2007 23:45:29 -0800
[]
> On Wed, 07 Mar 2007 15:39:27 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
>
>> Thanks a lot, could you please give me a script just to kill this
>> whitespace? So I can do it before sending you patches.
>
>
> Is pretty simple:
>
> #!/bin/sh
> #
> # Strip any trailing whitespace which a unified diff adds.
> #
>
> strip1()
> {
> 	TMP=$(mktemp /tmp/XXXXXX)
> 	cp $1 $TMP
> 	sed -e '/^+/s/[ 	]*$//' < $TMP > $1
> 	rm $TMP
> }
>
> for i in $*
> do
> 	strip1 $i
> done
>
>
> that'll be in
> http://www.zip.com.au/~akpm/linux/patches/patch-scripts-0.20/patch-scripts-0.20.tar.gz
> too

It doesn't work for me. Maybe i can't understand what you are trying to
do, anyway.

General suggestion is can be:

   sed -e 's_[ \t]*$__'

(i.e any line on stdin with space/tab mixed tails is stripped on stdout)

You can use it as wrapper for diff, sending patch bombs, etc.
(very nice with pipes):

shell$ diff -Npu2 old new | sed -e 's_[ \t]*$__' > patch.diff
shell$ < patch-set.mbox sed -e 's_[ \t]*$__' | formail -s /usr/sbin/sendmail -bm -t 

similar in scripts; quilt (patch sets manager) notices about them.
____
