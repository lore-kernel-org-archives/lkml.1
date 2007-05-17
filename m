Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbXEQIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbXEQIVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXEQIVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:21:00 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:18432 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEQIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ooTDD71/NTgmNfxhbC0twVTs825UAP+cdOB7Sne0FUXjcom4piez6ojR/1SsrmHGoDStfqPgmzPlJftYOchCLjcIn0Vyl/zbDU3qEAg6zdmDVszxWD3b+7jaK8MkYQveEBbDCahxmlYKsqrNwgWjONzhCjqoLuS6xQFt4AT6fIc=
Message-ID: <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
Date: Thu, 17 May 2007 17:20:56 +0900
From: "Dongjun Shin" <djshin90@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH] LogFS take three
Cc: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, "Albert Cahalan" <acahalan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Greg KH" <greg@kroah.com>,
       "Ingo Oeser" <ioe-lkml@rameria.de>
In-Reply-To: <1179383117.2859.416.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
	 <1179330596.2859.248.camel@shinybook.infradead.org>
	 <20070516164158.GB8113@lazybastard.org>
	 <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
	 <1179383117.2859.416.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, David Woodhouse <dwmw2@infradead.org> wrote:
>
> Yes. These things are almost always implemented _very_ badly by the same
> kind of crack-smoking hobo they drag in off the streets to write BIOSen.
>
> It's bog-roll technology; if you fancy a laugh try doing some real
> reliability tests on them time some. Powerfail testing is a good one.
>
> This kind of thing is OK for disposable storage such as in digital
> cameras, where it doesn't matter that it's no more reliable than a
> floppy disc, but for real long-term storage it's really a bad idea.
>

There are so many flash-based storage and some disposable storages,
as you pointed out, have poor quality. I think it's mainly because these
are not designed for good quality, but for lowering the price.

These kind of devices are not ready for things like power failure because
their use case is far from that. For example, removing flash card
while taking pictures using digital camera is not a common use case.
(there should be a written notice that this kind of action is against
the warranty)

>
> There's little point in optimising a file system _specifically_ for
> devices which in often aren't reliable enough to keep your data anyway.
> You might as well use ramfs.
>
> It's unfortunate really -- there's no _fundamental_ reason why FTL has
> to be done so badly; it's just that it almost always is. Direct access
> to the flash from Linux is _always_ going to be better in practice --
> and that way you avoid the problems with dual journalling, along with
> the problems with the underlying FTL continuing to keep (and copy around
> during GC) sectors which the top-level filesystem has actually
> deallocated, etc.
>

There are, of course, cases where direct access are better.
However, as the demand for capacity, reliability and high performance
for the flash storage increases, the use of FTL with embedded controller
would be inevitable.

- The complexity/cost of host-side SW (like JFFS2/MTD) will increase due to
the use of multiple flash in parallel and the use of high degree ECC algorithm.
There are other things like bad block handling and wear-leveling issues
which has been recently touched by UBI with added SW complexity.

- In contrast to the embedded environment where CPU and flash is directly
connected, the I/O path between CPU and flash in PC environment is longer.
The latency for SW handshaking between CPU and flash will also be longer,
which would make the performance optimization harder.

As I mentioned, some techniques like log-structured filesystem could
perform generally better on any kind of flash-based storage with FTL.
Although there are many kinds of FTL, it is commonly true that
it performs well under workload where sequential write is dominant.

I also expect that FTL for PC environment will have better quality spec
than the disposable storage.

Dongjun
