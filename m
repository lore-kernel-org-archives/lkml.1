Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXIFUTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXIFUTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbXIFUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:18:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19451 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbXIFUS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:18:56 -0400
Date: Thu, 6 Sep 2007 13:17:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Warning about init section reference in start_kernel
 (2.6.23-rc4-mm1)
Message-Id: <20070906131706.376af88b.randy.dunlap@oracle.com>
In-Reply-To: <20070906194632.GB4518@Krystal>
References: <20070906194632.GB4518@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2007 15:46:32 -0400 Mathieu Desnoyers wrote:

> Hi Peter,
> 
> I have seen the following warning on the recent -mm kernels when
> compiling a i386 kernel:
> 
>   scripts/mod/modpost   -o /home/compudj/git/morestable/linux-2.6-lttng/Module.symvers    vmlinux.o
> WARNING: vmlinux.o(.text.head+0x223): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
> 
> It looks like head.S jumps to start_kernel at the end of is386. Is this
> ok and valid ? If yes, then I guess modpost should be updated.

[added Sam]

This has come up several times.  Yes, it's OK.

If we could add __init_refok to is386 in head.S, this problem would
be fixed, but afaik we cannot do that.
Or modpost could have special knowledge of this one quirk, but that's
not desirable either.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
