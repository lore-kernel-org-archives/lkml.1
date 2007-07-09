Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXGILpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXGILpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXGILoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:44:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:13354 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXGILoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:44:54 -0400
Date: Mon, 9 Jul 2007 13:44:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravenborg.org
Subject: Re: [PATCH] fixup binutils printing from scripts/ver_linux
In-Reply-To: <46921E87.8000309@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707091341260.32335@fbirervta.pbzchgretzou.qr>
References: <200707090147.58611.jesper.juhl@gmail.com>
 <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com>
 <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
 <46921E87.8000309@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 13:39, Gabriel C wrote:
>
> Uhh :) Ok here an ugly one :
>
> $ ld -v | sed 's/.*version//;s/.*Binutils)//'|awk '{print $1}'|tr -d ' '
> 2.17.50.0.16.20070511
>
> $ echo 'GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)' | sed
> 's/.*version//;s/.*Binutils)//'|awk '{print $1}'|tr -d ' '
> 2.17.50.0.5
>
> $ echo 'GNU ld version 2.16.1' | sed 's/.*version//;s/.*Binutils)//'|awk
> '{print $1}'|tr -d ' '
> 2.16.1

That could be more beautiful :)
For example (untested)

#!/bin/bash
set -- (`ld -v`);
while [ "$1" != "version" -a $# -gt 0 ]; then
	shift;
done;
if [ "$1" == "version" ]; then
	version="$2";
fi;
if [ -z "$version" ]; then
	echo ld missing or could not figure.
else
	echo "BINUTILS: $version";
fi;


	Jan
-- 
