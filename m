Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZGHM2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZGHM2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZGHM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:28:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57108 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZGHM2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907080750100.23552@localhost>
References: <200907072336.14767.florian@openwrt.org>
	 <154e089b0907071654o46145717h17ac558aa4d524e0@mail.gmail.com>
	 <200907080840.44451.florian@openwrt.org>
	 <alpine.LFD.2.00.0907080750100.23552@localhost>
Date: Wed, 8 Jul 2009 14:28:43 +0200
Message-ID: <154e089b0907080528h24b6ccc6qa07bb1fa4db89aa0@mail.gmail.com>
Subject: Re: [PATCH] vlynq: remove duplicated #include
From: Hannes Eder <hannes@hanneseder.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Florian Fainelli <florian@openwrt.org>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Huang Weiyi <weiyi.huang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 13:50, Robert P. J. Day<rpjday@crashcourse.ca> wrote:
> On Wed, 8 Jul 2009, Florian Fainelli wrote:
>
>> Hi Hannes,
>>
>> Le Wednesday 08 July 2009 01:54:14 Hannes Eder, vous avez écrit :
>> > On Tue, Jul 7, 2009 at 23:36, Florian Fainelli<florian@openwrt.org> wrote:
>> > > Remove duplicated #include('s) in drivers/vlynq/vlynq.c
>> >
>> > The following little script catches more of these issues, though it
>> > might be a bit fragile:
>> >
>> > #!/bin/bash
>> > find . -name "*.c" | \
>> > while read file; do
>> >     dblinc=$(grep "^#include <" $file | sort | uniq -c | grep -v "^      1
>> > ") [ "$dblinc" != "" ] && echo $file: $dblinc
>> > done
>> >
>> > when ran from the linux-2.6 src tree, the output is something like
>> > (lines starting with '#' are my annotations):
>> >
>> > ./mm/slab.c: 3 #include <linux/kmalloc_sizes.h>
>> > # this is a false positive
>> > ./mm/slqb.c: 2 #include <linux/seq_file.h>
>> > # I did not look a this one
>> > ./mm/shmem.c: 2 #include <linux/vfs.h>
>> > # this is a hit
>> > # the rest (about 50 hits) skipped
>> >
>> > Do you want to investigate this issues?
>>
>> I will not, at least not now, but Huang (CC'd) might be interested.
>
>  isn't "make includecheck" supposed to identify duplicated includes?
> why aren't you using that?

Hey man, do not stop me from invent the wheel again, and again, and
again, ... ;).  You are right "make includecheck" does the trick check
for duplicated includes, in it does so in a much nicer way.

Thanks,
-Hannes
