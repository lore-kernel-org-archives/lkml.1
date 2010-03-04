Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0CDUkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:40:08 -0500
Received: from ozlabs.org ([203.10.76.45]:43416 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0CDUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:40:06 -0500
From: Michael Neuling <mikey@neuling.org>
To: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
cc: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: restrict initial stack space expansion to rlimit - the process killer...
In-reply-to: <op.u81oymnjzipv1w@pawels.alatek.krakow.pl>
References: <op.u8zxvxnpzipv1w@pawels.alatek.krakow.pl> <op.u81dn2i8zipv1w@pawels.alatek.krakow.pl> <2375c9f91003040205y7dff89bbl96de381f9e1393bc@mail.gmail.com> <op.u81oymnjzipv1w@pawels.alatek.krakow.pl>
Comments: In-reply-to =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
   message dated "Thu, 04 Mar 2010 14:26:36 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 05 Mar 2010 07:40:04 +1100
Message-ID: <25328.1267735204@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <op.u81oymnjzipv1w@pawels.alatek.krakow.pl> you wrote:
> Dnia 04-03-2010 o 11:05:03 Am=C3=A9rico Wang <xiyou.wangcong@gmail.com> =
>  =
> 
> napisa=C5=82(a):
> 
> > 2010/3/4 Pawe=C5=82 Sikora <pawel.sikora@agmk.net>:
> >> Hi all,
> >>
> >> i'm currently testing the 2.6.32.9 and observing random process killi=
> ng
> >> on my builder machine (x86-64) which contains several tcl/bash
> >> scripts for svn checkout, compilation, archive and ftp deploying.
> >>
> >> here's a fragment of build log:
> >>
> >> (...)
> >> [CXX] obj-release-i486-gnu-linux/genMappingRst.o
> >> [CXX] obj-release-i486-gnu-linux/otelloVerdiThread.o
> >> i486-gnu-linux-g++: Internal error: Killed (program as)
> >> Please submit a full bug report.
> >> See <http://gcc.gnu.org/bugs.html> for instructions.
> >> make[1]: *** [obj-release-i486-gnu-linux/genMappingRst.o] Error 1
> >>
> >> the builder process tree looks like this:
> >>
> >> $ pstree -Acl
> >> ?---screen-+-bash---loop.sh-+-loop.sh---tclsh8.4---temp_9_12676174---=
> tclsh8.4---temp_3_12676174---tclsh8.4---temp_4_12676174---tclsh8.4---tem=
> p_9_12676176---make---make-+-sh---ccache---x86_64-gnu-linu-+-as
> >>             |
> >> |
> >> |                               `-cc1plus
> >>             |
> >> |
> >> `-sh---ccache---x86_64-gnu-linu-+-as
> >>             |
> >> |
> >> `-cc1plus
> >>             |                `-tee
> >>             `-bash---pstree
> >>
> >>
> >> as you can see there're few levels of bash and tclsh(8.4)
> >> and make/ccache/binutils/g++ workers at the bottom.
> >>
> >> i've noticed that rolling back to the 2.6.32.8 (or just reverting
> >> the 'ulimit -s' commit: 35e2093d5d7b632c083af3578c05876375828314)
> >> fixes the problem.
> >>
> >> so, is it my stack ulimit (8192) to small, or maybe the new limit
> >> calculations are wrong? shoud i bump the stack limit for new kernels?=
> 
> >
> >
> > Please check if you have this patch:
> >
> > http://lkml.org/lkml/2010/2/15/61
> >
> > Thanks!
> 
> 2.6.32.9 + a17e18790a8c47113a73139d54a375dc9ccd8f08 works fine.
> i think it should be pushed to 2.6.32.10 as soon as possible.

Agreed.  It unfortunately missed .9 by a few hours.

Mikey
