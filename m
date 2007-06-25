Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXFYURu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXFYURu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXFYURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:17:42 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42626 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXFYURl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:17:41 -0400
Date: Mon, 25 Jun 2007 22:18:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: arjan@infradead.org, schilling@fokus.fraunhofer.de,
       linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <20070625201846.GB12937@uranus.ravnborg.org>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <1182469678.2704.16.camel@laptopd505.fenrus.org> <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 04:53:55PM +0200, Joerg Schilling wrote:
> 
> star needs "ext2_fs.h". This file is not usable at all on many Linux 
> distributions, even with GCC.

I was curious so I did:

$ mkdir ~/foo
$ cd ~/kernel/linux-2.6
$ make INSTALL_HDR_PATH=~/foo
$ cd ~/foo
$ cat j.c
#include <stdio.h>
#include "etx2_fs.h"

main()
{
	printf("helloo\n");
}

$ gcc -o j j.c
=> No warning, no errors

$ gcc -ansi -pedantic -o j j.c
In file included from j.c:2:
ext2_fs.h:53:25: warning: ISO C does not permit named variadic macros

$ gcc -ansi -pedantic -std=c99 -o j j.c
In file included from j.c:2:
ext2_fs.h:53:25: warning: ISO C does not permit named variadic macros
j.c:5: warning: return type defaults to ‘int’

Is it this part you are referring to in the above or have I overlooked something?

	Sam
