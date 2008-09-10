Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYIJGzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYIJGzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIJGzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:55:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbYIJGzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:55:14 -0400
Date: Wed, 10 Sep 2008 08:55:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Message-ID: <20080910065503.GA31059@elte.hu>
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Steven Noonan <steven@uplinklabs.net> wrote:

> Fixed the warning by initializing 'rc' to zero.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

i've Cc:-ed Bartlomiej, who maintains drivers/ide/ide-probe.c. Your 
fix/cleanup looks fine to me.

About the "whom to Cc:" question. Sadly, the MAINTAINERS file is 
non-obvious to parse to newbies: there's no clear mapping from file to 
maintainer. (it's rather useless even to oldbies.)

The method i use to determine whom to Cc: if i change something in a 
file is this ~/bin/git-authors script:

 #!/bin/bash
 git log $@ | grep Author: | cut -d: -f2 | sort | uniq -c | sort -n | tail -5

(also attached)

for drivers/ide/ide-probe.c, it gives:

 earth4:~/tip> git-authors-email drivers/ide/ide-probe.c
       2  Christoph Lameter <christoph@lameter.com>
       2  Greg Kroah-Hartman <gregkh@suse.de>
       3  Jens Axboe <jens.axboe@oracle.com>
       4  Jens Axboe <axboe@suse.de>
     135  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

if there output of git-authors-email is too flat and you are unsure 
about whom to Cc:, take a look at git-log drivers/ide/ide-probe.c output 
and chose the people who do material changes to a file (not drive-by 
changes).

	Ingo

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=git-authors-email


#[ $# -lt "1" ] && { echo 'usage: git authors <files...>'; exit -1; }

git log $@ | grep Author: | cut -d: -f2 | sort | uniq -c | sort -n | tail -5



--vkogqOf2sHV7VnPd--
