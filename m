Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZKKLAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZKKLAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbZKKLAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:00:13 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54343 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbZKKLAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:00:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UNxj9Rat7v5izR6vsmLRmBY8ZHXweoA989Swun86UYVZ6we8ECQ61qfKADFHIf6Ord
         57WCHNtJujuGf5NbAQhMoC5XzGgnX7sMeHOSgh/uBNAFXw0prN+eE0R0bT4R6avhUxDk
         qy2I8qaAwHVvz6a+/NQA+6ihZZEW6MTmj6sbg=
MIME-Version: 1.0
In-Reply-To: <40e92d5b0911101608t4baf75bo83c5780f24761781@mail.gmail.com>
References: <40e92d5b0911101608t4baf75bo83c5780f24761781@mail.gmail.com>
Date: Wed, 11 Nov 2009 12:00:17 +0100
Message-ID: <4e5e476b0911110300nb25785eqf7998ad1fe3ed537@mail.gmail.com>
Subject: Re: SATA NCQ - blessing for throughput, curse for latency?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
2009/11/11 Przemysław Pawełczyk <przemyslaw@pawelczyk.it>:
> Hi,
>
> [snip] I wrote a script (that is pasted
> at the end), which using zcav from bonnie++ (and unbuffer from expect
> to work properly if output is redirected to a file) reads up to 64 GB
> of the disk, but after a first few gigabytes (depending on how many GB
> of memory you have) cats kernel sources with binary files up to the
> second level of directory depth. What is measured? The real time of
> the cat to /dev/null operation. Why not the kernel sources alone?
> Because if we build kernel, especially with -jX (where X > 1), then
> both inodes and contents of the corresponding files within these
> directories generally won't be consecutive. Time for the results with
> some background information. In my tests I have used 2.6.31.5 built
> with debuginfo (using debian's make-kpkg).
>
>[summarized the relevant numbers]
> *** NCQ turned on ***
> real 752.30
> user 0.20
> sys 1.83
>
>
> *** NCQ turned off *** (kernel booted with noncq parameter)
> real 62.30
> user 0.27
> sys 1.59
>
> [snip]
>
> Can anyone confirm analogous NCQ-dependant behavior with other
> disk/controller variants? Any suggestions for improvements other than
> turning off NCQ or switching to anticipatory (in typical cases cfq is
> better, so it's not the best option)?

The NCQ latency problem is well known, and should be fixed in 2.6.32.
You can try building the latest rc.

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
