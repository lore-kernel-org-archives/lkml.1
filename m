Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXI1Nai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXI1Nai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbXI1NaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:30:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:7795 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbXI1NaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K5n4mG5H0TbNd6DuRnbSAvfU3Zi0x+s31msZzumOTQLSwgxSNw1j2kWalcxud1rfmAXYeb4K3lpLxPJDR3E2tC6d73KfLu3QrkQIa0fRQ54i6/GDfyCc6wokb1pIK/c7BHnJ9d38EK8IKyM+AHUlD/Ey24b1ZJTCeqBNFUp55V4=
Message-ID: <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
Date: Fri, 28 Sep 2007 15:30:08 +0200
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Out of memory management in embedded systems
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	 <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>
> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
>
> > Applications with dynamic input and dynamic memory usage have some
> > issues with the current overcommitting kernel. A high memory usage
> > situation eventually results in that a process is killed by the OOM
> > killer. This is especially evident in swapless embedded systems with
> > limited memory and no swap available.
> >
> > Some kind of notification to the application that the available memory
> > is scarce and let the application free up some memory (e.g., by
> > flushing caches), could be used to improve the situation and avoid the
> > OOM killer. I am currently not aware of any general solution to this
> > problem, but I have found some approaches that might (or might not)
> > work:
> >
> > o Turn off overcommit. Results in a waste of memory.
> >
> > o Nokia uses a lowmem security module to signal on predetermined
> > thresholds. Currently available in the -omap tree. But this requires
> > manual tuning of the thresholds.
> > http://www.linuxjournal.com/article/8502
> >
> > o Using madvise() with MADV_FREE to get the kernel to free mmaped
> > memory, typically application caches, when the kernel needs the
> > memory.
> >
> > o A OOM handler that the application registers with the kernel, and
> > that the kernel executes before the OOM-killer steps in.
> >
> > Does it exist any other solutions to this problem?
> >
> > Daniel
> > -
>
> But an embedded system contains all the software that will
> ever be executed on that system! If it is properly designed,
> it can never run out of memory because everything it will
> ever do is known at design time.

Not if its input is not known beforehand. Take a browser in a mobile
phone as an example, it does not know at design time how big the web
pages are. On the other hand we want to use as much memory as
possible, for cache etc., a method that involves the kernel would
simplify this and avoids setting manual limits.

Daniel
