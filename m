Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYIQOLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYIQOLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYIQOLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:11:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:57808 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYIQOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=X3EbAmxkBdR0tEbCHljIkAzTHvcYy48NJRPiVTSAZI2/feauBufwinr5F4MScU7tPy
         WRjos9tzwTb9bOZLsUSjB0WAEsjTtrSddqfNfftOw6JJsOmYzjbegj8puAiENt/43ZVE
         rzT8/3YFhe4y+SipVVxXDpzeJ2z+SM6mhrnPE=
Message-ID: <43c7dbff0809170711h3a48ff4ia3e6d89838868103@mail.gmail.com>
Date: Wed, 17 Sep 2008 22:11:31 +0800
From: "yun lin" <liny.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Virtual Memory problem in kernel 2.4.18xsmp
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   I am using redhat 8 (kernel 2.4.18 xsmp) on an old cluster (2CPU
each nodes, 2GB RAM, 4GB swap and NFS). Recently I had encountered a
problem about virtual memory. A parallel program terminated with
Segmentation fault (Signal 11). While using gdb to debug, it turns out
that the exact error message is "virtual memory exhausted". The
program was compiled using Intel compiler 8.1. I had compiled it on a
CentOS 5.2(2GB RAM, 4GB swap) with Intel compiler 10.1, and the
program runs well. It requires about 200 MB RAM, as watching by 'top'
command. And during its running, 'kswapd' demon would be awakened.
   While running this program in the cluster, it always dies when the
RSS reach about 150MB with a signal 11 (or using gdb with 'virtual
memory exhaust'). During its running, the system has more than 1.2GB
free RAM, 4GB free swap and the 'kswapd' keeps in 'SW' status. I had
checked the /etc/security/limits.conf file, which sets no limit. And I
had tried bash and csh with the stack size, virtual memory, max memory
size, file size unlimited. I had also doubled the max_map_count in
/proc/sys/vm/. But all of the above actions had no effect on the
program, it still died when it occupies about 150MB RAM and reports
Sig 11 (in gdb 'VM exhauxted'). I had manually set some limits on the
virtual memory (such as 'virtual memory' limit in the shell or
max_map_count), the program dies with some different message like
'forrtl: not enough virtual memory ...."
   Are there any other limits that restrain a process from getting
more virtual memory? I had tried to speed up the fresh frequency of
'kswapd', but I can't find 'freepages' file in my /proc/sys/vm
directory. It is said that this key had been removed since kernel 2.4,
so how can I increase the fresh frequency of 'kswapd'? Besides, are
there any special rules in virtual memory control of SMP kernel?
   Thanks for reading my letters. I hope to get some helps.
