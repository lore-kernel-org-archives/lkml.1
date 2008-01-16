Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYAPBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYAPBYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYAPBYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:24:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55437 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYAPBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:24:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Tap3Zv82/SPkbd0gUzkb1qnTz78RARYPTHGgnXA9IPxFXsSqB9TGowtzpZKFwS4Mp
	WR5bgAT1fWeTrM7fLldFQ==
Message-ID: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com>
Date: Tue, 15 Jan 2008 20:24:27 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Chinner" <dgc@sgi.com>,
       "Theodore Tso" <tytso@mit.edu>, "Al Boldi" <a1426z@gawab.com>,
       "Valerie Henson" <val.henson@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801090022.55589.a1426z@gawab.com>
	 <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
	 <20080113171916.GB4132@ucw.cz>
	 <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	 <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com>
	 <20080115230714.GC3573@elf.ucw.cz>
	 <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
	 <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 7:15 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Writeback cache on disk in iteself is not bad, it only gets bad if the
> > disk is not engineered to save all its dirty cache on power loss,
> > using the disk motor as a generator or alternatively a small battery.
> > It would be awfully nice to know which brands fail here, if any,
> > because writeback cache is a big performance booster.
>
> AFAIK no drive saves the cache. The worst case cache flush for drives is
> several seconds with no retries and a couple of minutes if something
> really bad happens.
>
> This is why the kernel has some knowledge of barriers and uses them to
> issue flushes when needed.

Indeed, you are right, which is supported by actual measurements:

    http://sr5tech.com/write_back_cache_experiments.htm

Sorry for implying that anybody has engineered a drive that can do
such a nice thing with writeback cache.

The "disk motor as a generator" tale may not be purely folklore.  When
an IDE drive is not in writeback mode, something special needs to done
to ensure the last write to media is not a scribble.

A small UPS can make writeback mode actually reliable, provided the
system is smart enough to take the drives out of writeback mode when
the line power is off.

Regards,

Daniel
