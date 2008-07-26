Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYGZOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYGZOeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYGZOeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:34:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:48406 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYGZOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w3CQD398NDXgf3+yZiqgbCdFfbMESFTe15R50eDwO1xID2g4V5V4fB20LRRXQnKB+S
         ImxVxsSqhsKO1U5t8b4rxBOa/ivk2R+5R5BRFS68TBjvxIjL0CYO76XNVlcLbMk0aaUB
         PgVDfR6odruHiBsq2pnD7XATU1RW9qSRXy2Vk=
Date: Sat, 26 Jul 2008 18:33:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kel Modderman <kel@otaku42.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: tmpfs: kernel BUG at mm/shmem.c:814
Message-ID: <20080726143359.GA13662@martell.zuzino.mipt.ru>
References: <200807262210.11502.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807262210.11502.kel@otaku42.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 10:10:11PM +1000, Kel Modderman wrote:
> # mount -t tmpfs -o mode=1777 tmpfs /var/tmp/
> # exit
> $ cd /var/tmp/
> $ wget -q http://users.tpg.com.au/sigm/misc/insserv-1.11.10-shmem.tar.gz
> $ tar xzf insserv-1.11.10-shmem.tar.gz
> $ cd insserv-1.11.10/
> $ make
> gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -falign-loops=0 -c insserv.c
> gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -falign-loops=0 -c listing.c
> gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -Wl,-O,3,--relax -o insserv insserv.o listing.o
> sed -r '\!@@BEGIN_SUSE@@!,\!@@(ELSE|END)_SUSE@@!d;\!@@(NOT|END)_SUSE@@!d' < insserv.8.in > insserv.8
> $ chmod +x tests/run-testsuite
> $ ./tests/run-testsuite

> ------------[ cut here ]------------
> kernel BUG at mm/shmem.c:814!

Perfectly reproducible, thanks for testcase.

