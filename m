Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXIKQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXIKQOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXIKQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:14:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38105 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXIKQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:14:13 -0400
Date: Tue, 11 Sep 2007 18:14:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
In-Reply-To: <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Message-ID: <Pine.LNX.4.64.0709111813100.9962@fbirervta.pbzchgretzou.qr>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
 <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 17:54, Ulrich Windl wrote:
>> > Aug 31 15:04:40 kgate1 kernel: powersaved[10102]: segfault at 0000000000000008 rip 
>> > 000000000042c17a rsp 00007fffea55de00 error 4
>[...]
>> segfaulting are sysloged only on 64bits kernel.
>> 
>> Maybe your slapd/hscan processes are doing bad things, that make them 
>> core dump without notice on a 32bits kernel.
>
>A very wild guess: AFAIK SUSE Distributions are XENified recently,

Not only recently..

>I also learned that the error code is only documented for i386 arch (thanks to 
>Emacs ediff):
> * error_code:
> *      bit 0 == 0 means no page found, 1 means protection fault
> *      bit 1 == 0 means read, 1 means write
> *      bit 2 == 0 means kernel, 1 means user-mode
>
>So the problem (error 4) looks a bit like a read on a NULL-pointer
>dereference, right? And the "rip" is user space, correct?

rip points to userspace. If you are about dereferencing, look at
rax. If it is 0, it usually is logical what happened.
If it is slightly above, someone tried to access like foo->bar
where foo==NULL.
