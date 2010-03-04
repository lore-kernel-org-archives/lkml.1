Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0CDKFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:05:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34084 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0CDKFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tSReQ9XMgu76YjHFwBuf8WlTS3tKh/FQqg64khUvjJ82wHQzfqU8U+s2Z+RRcregH/
         CmuPc4j1DiA+3Z6WmBdI7yiK9uS+OO1UJ6oYE5npEb8DlK3hZ+wX4xmVOdZVXzspUBtA
         B7Q+KQJvi+7km45aPNnYp1gVYYmEXCwt7MmD8=
MIME-Version: 1.0
In-Reply-To: <op.u81dn2i8zipv1w@pawels.alatek.krakow.pl>
References: <op.u8zxvxnpzipv1w@pawels.alatek.krakow.pl>
	 <op.u81dn2i8zipv1w@pawels.alatek.krakow.pl>
Date: Thu, 4 Mar 2010 18:05:03 +0800
Message-ID: <2375c9f91003040205y7dff89bbl96de381f9e1393bc@mail.gmail.com>
Subject: Re: restrict initial stack space expansion to rlimit - the process 
	killer...
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: =?UTF-8?Q?Pawe=C5=82_Sikora?= <pawel.sikora@agmk.net>
Cc: linux-kernel@vger.kernel.org, mikey@neuling.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/4 Paweł Sikora <pawel.sikora@agmk.net>:
> Hi all,
>
> i'm currently testing the 2.6.32.9 and observing random process killing
> on my builder machine (x86-64) which contains several tcl/bash
> scripts for svn checkout, compilation, archive and ftp deploying.
>
> here's a fragment of build log:
>
> (...)
> [CXX] obj-release-i486-gnu-linux/genMappingRst.o
> [CXX] obj-release-i486-gnu-linux/otelloVerdiThread.o
> i486-gnu-linux-g++: Internal error: Killed (program as)
> Please submit a full bug report.
> See <http://gcc.gnu.org/bugs.html> for instructions.
> make[1]: *** [obj-release-i486-gnu-linux/genMappingRst.o] Error 1
>
> the builder process tree looks like this:
>
> $ pstree -Acl
> ?---screen-+-bash---loop.sh-+-loop.sh---tclsh8.4---temp_9_12676174---tclsh8.4---temp_3_12676174---tclsh8.4---temp_4_12676174---tclsh8.4---temp_9_12676176---make---make-+-sh---ccache---x86_64-gnu-linu-+-as
>             |
> |
> |                               `-cc1plus
>             |
> |
> `-sh---ccache---x86_64-gnu-linu-+-as
>             |
> |
> `-cc1plus
>             |                `-tee
>             `-bash---pstree
>
>
> as you can see there're few levels of bash and tclsh(8.4)
> and make/ccache/binutils/g++ workers at the bottom.
>
> i've noticed that rolling back to the 2.6.32.8 (or just reverting
> the 'ulimit -s' commit: 35e2093d5d7b632c083af3578c05876375828314)
> fixes the problem.
>
> so, is it my stack ulimit (8192) to small, or maybe the new limit
> calculations are wrong? shoud i bump the stack limit for new kernels?


Please check if you have this patch:

http://lkml.org/lkml/2010/2/15/61

Thanks!
