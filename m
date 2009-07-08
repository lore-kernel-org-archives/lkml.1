Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZGHLWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZGHLWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZGHLVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:21:52 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:37551 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZGHLVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nitSbEyoXxPYAAekPMFcr4tp0xFZ/Aj4SYqjSzPdV3YM9c34sfUZ7RffM5vIzPV5A6
         naPYCTEbF6Af1c+t5oQ6DfI91CXlUd5DQKSDS4oyEAWclkx1Rn2R7TZuyAFEuqkSa/QN
         IVwA0inVcO+xWqvsXPGnyyhoUux8kPVosP9bY=
From: Florian Fainelli <florian@openwrt.org>
To: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] vlynq: remove duplicated #include
Date: Wed, 8 Jul 2009 08:40:43 +0200
User-Agent: KMail/1.9.9
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Weiyi <weiyi.huang@gmail.com>
References: <200907072336.14767.florian@openwrt.org> <154e089b0907071654o46145717h17ac558aa4d524e0@mail.gmail.com>
In-Reply-To: <154e089b0907071654o46145717h17ac558aa4d524e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907080840.44451.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

Le Wednesday 08 July 2009 01:54:14 Hannes Eder, vous avez écrit :
> On Tue, Jul 7, 2009 at 23:36, Florian Fainelli<florian@openwrt.org> wrote:
> > Remove duplicated #include('s) in drivers/vlynq/vlynq.c
>
> The following little script catches more of these issues, though it
> might be a bit fragile:
>
> #!/bin/bash
> find . -name "*.c" | \
> while read file; do
>     dblinc=$(grep "^#include <" $file | sort | uniq -c | grep -v "^      1
> ") [ "$dblinc" != "" ] && echo $file: $dblinc
> done
>
> when ran from the linux-2.6 src tree, the output is something like
> (lines starting with '#' are my annotations):
>
> ./mm/slab.c: 3 #include <linux/kmalloc_sizes.h>
> # this is a false positive
> ./mm/slqb.c: 2 #include <linux/seq_file.h>
> # I did not look a this one
> ./mm/shmem.c: 2 #include <linux/vfs.h>
> # this is a hit
> # the rest (about 50 hits) skipped
>
> Do you want to investigate this issues?

I will not, at least not now, but Huang (CC'd) might be interested.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
