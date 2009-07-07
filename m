Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZGGXyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZGGXyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZGGXyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:54:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:18956 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbZGGXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <200907072336.14767.florian@openwrt.org>
References: <200907072336.14767.florian@openwrt.org>
Date: Wed, 8 Jul 2009 01:54:14 +0200
Message-ID: <154e089b0907071654o46145717h17ac558aa4d524e0@mail.gmail.com>
Subject: Re: [PATCH] vlynq: remove duplicated #include
From: Hannes Eder <hannes@hanneseder.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 23:36, Florian Fainelli<florian@openwrt.org> wrote:
> Remove duplicated #include('s) in drivers/vlynq/vlynq.c

The following little script catches more of these issues, though it
might be a bit fragile:

#!/bin/bash
find . -name "*.c" | \
while read file; do
    dblinc=$(grep "^#include <" $file | sort | uniq -c | grep -v "^      1 ")
    [ "$dblinc" != "" ] && echo $file: $dblinc
done

when ran from the linux-2.6 src tree, the output is something like
(lines starting with '#' are my annotations):

./mm/slab.c: 3 #include <linux/kmalloc_sizes.h>
# this is a false positive
./mm/slqb.c: 2 #include <linux/seq_file.h>
# I did not look a this one
./mm/shmem.c: 2 #include <linux/vfs.h>
# this is a hit
# the rest (about 50 hits) skipped

Do you want to investigate this issues?

Cheers,
Hannes
