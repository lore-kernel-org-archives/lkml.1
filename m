Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYKQTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYKQTmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKQTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:42:12 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:15543 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKQTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:42:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e70+uRH7GPSjk/qcMnsb15elw8ay7ibScU6nHWwSzoQwLmj3nFJ5+ESPblkp51mYnD
         /HOzBi020nsCyjRA9nqmU/X1aZSivojxw+25YVV2P2DL/B2uPLMcfIwVaFwQ7u3oORXL
         3YIphh2J+Zj3Cmua6pDeC/UADhYGt+wykYXY8=
Message-ID: <ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
Date: Mon, 17 Nov 2008 21:42:09 +0200
From: "Victoria Muntean" <vikimun@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: size of swapped-out part of the process
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811171343340.11044@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
	 <Pine.LNX.4.64.0811171343340.11044@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/08, Hugh Dickins <hugh@veritas.com> wrote:
> On Mon, 17 Nov 2008, Victoria Muntean wrote:
>> How can I calculate size of swapped-out part of the process from
>> /proc/PID/*, even if approximately ?
>> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
>> swap-in-use==0.
>> Hence (VmSize - VmRSS) is far from being swapped-out part of the
>> process. What is ?
>
> I'm sorry, we don't record those numbers per process or per mm,
> so you won't find them in /proc/PID/status or /proc/PID/statm.
>
> And we'd probably resist accepting a patch to add them,
> so as not to enlarge key data structures to hold them.
>
> There's also an ambiguity about what "swapped-out" means: does
> it include shared file pages which were once mapped into the
> process, but have since been freed under memory pressure?
>
> But it looks like you're interested in swapped-out to mean written
> on swap.  In that case, if you have CONFIG_PROC_PAGE_MONITOR=y,
> you can read /proc/PID/smaps and add up all the "Swap:" lines.

Can you possibly explain what types of pages create  "VSZ>>RSZ"
effect in total absence of swapping and plenty of free memory ?
