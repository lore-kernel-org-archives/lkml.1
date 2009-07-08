Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZGHLxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZGHLxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZGHLxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:53:10 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43944 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZGHLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:53:08 -0400
Date: Wed, 8 Jul 2009 07:50:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Florian Fainelli <florian@openwrt.org>
cc: Hannes Eder <hannes@hanneseder.net>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH] vlynq: remove duplicated #include
In-Reply-To: <200907080840.44451.florian@openwrt.org>
Message-ID: <alpine.LFD.2.00.0907080750100.23552@localhost>
References: <200907072336.14767.florian@openwrt.org> <154e089b0907071654o46145717h17ac558aa4d524e0@mail.gmail.com> <200907080840.44451.florian@openwrt.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1840098635-1247053852=:23552"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1840098635-1247053852=:23552
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 8 Jul 2009, Florian Fainelli wrote:

> Hi Hannes,
>
> Le Wednesday 08 July 2009 01:54:14 Hannes Eder, vous avez =C3=A9crit=C2=
=A0:
> > On Tue, Jul 7, 2009 at 23:36, Florian Fainelli<florian@openwrt.org> wro=
te:
> > > Remove duplicated #include('s) in drivers/vlynq/vlynq.c
> >
> > The following little script catches more of these issues, though it
> > might be a bit fragile:
> >
> > #!/bin/bash
> > find . -name "*.c" | \
> > while read file; do
> >     dblinc=3D$(grep "^#include <" $file | sort | uniq -c | grep -v "^  =
    1
> > ") [ "$dblinc" !=3D "" ] && echo $file: $dblinc
> > done
> >
> > when ran from the linux-2.6 src tree, the output is something like
> > (lines starting with '#' are my annotations):
> >
> > ./mm/slab.c: 3 #include <linux/kmalloc_sizes.h>
> > # this is a false positive
> > ./mm/slqb.c: 2 #include <linux/seq_file.h>
> > # I did not look a this one
> > ./mm/shmem.c: 2 #include <linux/vfs.h>
> > # this is a hit
> > # the rest (about 50 hits) skipped
> >
> > Do you want to investigate this issues?
>
> I will not, at least not now, but Huang (CC'd) might be interested.

  isn't "make includecheck" supposed to identify duplicated includes?
why aren't you using that?

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1840098635-1247053852=:23552--
