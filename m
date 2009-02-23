Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZBWIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZBWIaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZBWIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:30:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZBWIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:30:04 -0500
Message-ID: <49A25E93.10708@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 16:30:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in
 	kernel/cgroup.c
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net> <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
In-Reply-To: <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Reduces object file size a bit :
>>
>> Before:
>> $ size kernel/cgroup.o
>>   text    data     bss     dec     hex filename
>>  21593    7804    4924   34321    8611 kernel/cgroup.o
>> After:
>> $ size kernel/cgroup.o
>>   text    data     bss     dec     hex filename
>>  21537    7744    4924   34205    859d kernel/cgroup.o
> 
> Thanks. I'm a bit surprised that it also shrunk the data segment size
> (and in fact, by more than the text segment size). Any idea how that
> came about?
> 

A bit odd..

Here is the result on my x86_32:
   text    data     bss     dec     hex filename
  14118    1804    4960   20882    5192 kernel/cgroup.o.orig
   text    data     bss     dec     hex filename
  14114    1804    4960   20878    518e kernel/cgroup.o

And on IA64:
   text    data     bss     dec     hex filename
  42399    2712    5616   50727    c627 kernel/cgroup.o.orig
   text    data     bss     dec     hex filename
  42367    2712    5616   50695    c607 kernel/cgroup.o

No change in data segment.
