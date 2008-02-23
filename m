Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYBWMmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYBWMmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYBWMlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:41:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:10298 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYBWMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p9eA3kZew/XkvjWJP4USMCwFO4RNWjIo811kvBCaXv+02jRG1Lsr9BqA8e3PqMkoj2XkhZifODWUA7SJIZP1XGRTWcb3QMiKN5mATW1giwUOom+GtnWr1WMI4goAmcV1K4fpPUpRn/niC6Mqemxh8EsJSsjS/br4FgXxvO/2RaM=
Message-ID: <661de9470802230441o43954211wfe77495a89f3677a@mail.gmail.com>
Date: Sat, 23 Feb 2008 18:11:46 +0530
From: "Balbir Singh" <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
To: linux-kernel@vger.kernel.org
Subject: Re: + cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, andi@firstfloor.org, ak@suse.de,
       menage@google.com
In-Reply-To: <200802230732.m1N7WmLQ018100@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802230732.m1N7WmLQ018100@imap1.linux-foundation.org>
X-Google-Sender-Auth: 665149ebafc4f6e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 1:02 PM,  <akpm@linux-foundation.org> wrote:
>
>  The patch titled
>      cgroup memory controller: document huge memory/cache overhead in Kconfig
>  has been added to the -mm tree.  Its filename is
>      cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch
>
>  Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
>  *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
>  See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>  out what to do about this
>
>  The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
>  ------------------------------------------------------
>  Subject: cgroup memory controller: document huge memory/cache overhead in Kconfig
>  From: Andi Kleen <andi@firstfloor.org>
>
>  Document huge memory/cache overhead of memory controller in Kconfig
>
>  I was a little surprised that 2.6.25-rc* increased struct page for the
>  memory controller.  At least on many x86-64 machines it will not fit into a
>  single cache line now anymore and also costs considerable amounts of RAM.
>  At earlier review I remembered asking for a external data structure for
>  this.
>
>  It's also quite unobvious that a innocent looking Kconfig option with a
>  single line Kconfig description has such a negative effect.
>
>  This patch attempts to document these disadvantages at least so that users
>  configuring their kernel can make a informed decision.
>
>  Signed-off-by: Andi Kleen <ak@suse.de>
>  Cc: Balbir Singh <balbir@in.ibm.com>
>  Acked-by: Paul Menage <menage@google.com>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>   init/Kconfig |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
>  diff -puN init/Kconfig~cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig init/Kconfig
>  --- a/init/Kconfig~cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig
>  +++ a/init/Kconfig
>  @@ -394,6 +394,14 @@ config CGROUP_MEM_CONT
>           Provides a memory controller that manages both page cache and
>           RSS memory.
>
>  +         Note that setting this option increases fixed memory overhead
>  +         associated with each page of memory in the system by 4/8 bytes
>  +         and also increases cache misses because struct page on many 64bit
>  +         systems will not fit into a single cache line anymore.
>  +
>  +         Only enable when you're ok with these trade offs and really
>  +         sure you need the memory controller.
>  +

Andrew,

I asked Andi what architectures have a cacheline size such that 56
bytes would fit in the cache, but 64 bytes would not. I have not heard
back. I would like Andi's approval to change the text to

         Note that setting this option increases fixed memory overhead
         associated with each page of memory in the system by 4/8 bytes
         Only enable when you're ok with these trade offs and really
         sure you need the memory controller.

Andi, please confirm at the earliest.

Balbir
