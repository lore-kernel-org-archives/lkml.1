Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbYIJGt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbYIJGt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYIJGtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:49:49 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:43350 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIJGts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Quq1htifFibRDhNAwwd5kXDgbZZHVgXkpfKGHXH3BqiWYD6rnY47P/btZhaCCvqNO7
         KReor0GxtKbaKr2nqzp0SIT3WJvbWbx0sgVNR04r2yzqxmUPD9yUn0DWq8OLYwkPLOJp
         sIBw/gviTLQJctXpqSR2lrzjOVDYnl/R0cJlQ=
Message-ID: <8bd0f97a0809092349y6ea47051m36f93fef19e2bad7@mail.gmail.com>
Date: Wed, 10 Sep 2008 02:49:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: arjan@linux.intel.com
Subject: vmlinux.lds.h initcall update breaks ABI prefixed arches
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commits ac9103dd8e4dc65c110d6cba9a3380c6c617ffa7 and
660625fb93f2fc0e633da9cb71d13d895b385f64 break any arch that has an
ABI prefix (like Blackfin).  when declaring symbols in vmlinux.lds.h,
you must wrap them in VMLINUX_SYMBOL(), else you break a couple of
arches.

in this case, the async/device initcall start/end results in:
init/built-in.o: In function `do_async_initcalls':
init/main.c:(.init.text+0x158): undefined reference to `__async_initcall_end'
init/main.c:(.init.text+0x15c): undefined reference to `__async_initcall_start'
init/main.c:(.init.text+0x160): undefined reference to `__async_initcall_end'
init/main.c:(.init.text+0x164): undefined reference to `__async_initcall_start'
init/built-in.o: In function `do_initcalls':
init/main.c:(.init.text+0x2cc): undefined reference to `__async_initcall_start'
init/main.c:(.init.text+0x2d0): undefined reference to `__async_initcall_start'
init/main.c:(.init.text+0x2f4): undefined reference to `__device_initcall_end'
init/main.c:(.init.text+0x2f8): undefined reference to `__device_initcall_end'
init/main.c:(.init.text+0x30a): undefined reference to `__async_initcall_end'
init/main.c:(.init.text+0x30e): undefined reference to `__async_initcall_end'
make: *** [.tmp_vmlinux1] Error 1
-mike
