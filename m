Return-Path: <linux-kernel-owner+w=401wt.eu-S933767AbXGUGC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbXGUGC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbXGUGCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:02:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33388 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbXGUGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nfEB77fyJzJmVq+Wr2JNVpk4Rgom6NkdDDuJWhncl90/gcNZH4qBLhR/jHY/aXwp4qQYh9JMYDWXp5JRTF4FZnr3L11JSqQJrOggxPTwJ4PRBES0M+CorTpgLL5KdZ4Fu7JTQoxJNvgLD5x8+4uCWpXal+rRMbXnY04Y6uZe3QI=
Message-ID: <dda83e780707202302g177d09acg94e77f724e97f17a@mail.gmail.com>
Date: Fri, 20 Jul 2007 23:02:12 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Ulrich Kunitz" <kune@deine-taler.de>
Subject: Re: Is PIE randomization breaking klibc binaries?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070720211300.GA21644@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720211300.GA21644@deine-taler.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Ulrich Kunitz <kune@deine-taler.de> wrote:
> Since this week new linux-2.6/master kernels don't work with my
> initial ram disks. The sleep binary runs repeatingly into
> segmentation faults until the Busybox shell starts. My system is a
> x86-64 with Kubuntu Feisty Fawn.
>
> By bisecting I found out that the PIE randomization patch (commit 60bfba7e)
> appears to cause the segmentation faults.
>
> Digging further into the issue I found out, that the sleep binary
> on the initial ramdisk is a klibc binary. /usr/bin/file says it is
> statically linked and uses shared libraries. I have no clue about
> klibc, but the binaries seem to be statically linked, but load a
> shared library; probably at a fixed address. Other klibc binaries are also
> running into segmentation faults. Busybox is working, but it is
> statically linked and doesn't use a shared library.
>
> It looks like that the PIE randomization patch breaks klibc
> binaries on x86-64.
>
> --
> Uli Kunitz
> -

oh bugger I just spent a few hours bisecting to find this headache
only to find someone else had 8 hours ago... *sigh*

anyhow also seeing seg faults here on a amd64 ubuntu system
reverting the PIE randomization patch made it go away
