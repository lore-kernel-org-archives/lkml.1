Return-Path: <linux-kernel-owner+w=401wt.eu-S937564AbXGUKSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937564AbXGUKSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760583AbXGUKSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:18:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759109AbXGUKSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:18:40 -0400
Date: Sat, 21 Jul 2007 03:18:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bret Towe" <magnade@gmail.com>
Cc: "Ulrich Kunitz" <kune@deine-taler.de>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <honza@jikos.cz>, Jiri Kosina <jkosina@suse.cz>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-Id: <20070721031809.54d573a9.akpm@linux-foundation.org>
In-Reply-To: <dda83e780707202302g177d09acg94e77f724e97f17a@mail.gmail.com>
References: <20070720211300.GA21644@deine-taler.de>
	<dda83e780707202302g177d09acg94e77f724e97f17a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 23:02:12 -0700 "Bret Towe" <magnade@gmail.com> wrote:

> On 7/20/07, Ulrich Kunitz <kune@deine-taler.de> wrote:
> > Since this week new linux-2.6/master kernels don't work with my
> > initial ram disks. The sleep binary runs repeatingly into
> > segmentation faults until the Busybox shell starts. My system is a
> > x86-64 with Kubuntu Feisty Fawn.
> >
> > By bisecting I found out that the PIE randomization patch (commit 60bfba7e)
> > appears to cause the segmentation faults.
> >
> > Digging further into the issue I found out, that the sleep binary
> > on the initial ramdisk is a klibc binary. /usr/bin/file says it is
> > statically linked and uses shared libraries. I have no clue about
> > klibc, but the binaries seem to be statically linked, but load a
> > shared library; probably at a fixed address. Other klibc binaries are also
> > running into segmentation faults. Busybox is working, but it is
> > statically linked and doesn't use a shared library.
> >
> > It looks like that the PIE randomization patch breaks klibc
> > binaries on x86-64.
> >
> > --
> > Uli Kunitz
> > -
> 
> oh bugger I just spent a few hours bisecting to find this headache
> only to find someone else had 8 hours ago... *sigh*
> 
> anyhow also seeing seg faults here on a amd64 ubuntu system
> reverting the PIE randomization patch made it go away

(cc's added)

I don't think we'll be fixing this in time for -rc1.  I'll revert
it.  Thanks for the prompt and accurate reporting.
