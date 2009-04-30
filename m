Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbZD3VJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbZD3VJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZD3VJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767AbZD3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:09:41 -0400
Date: Thu, 30 Apr 2009 14:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@cuplxvomd02.corp.sa.net, netdev@cuplxvomd02.corp.sa.net
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
 devices, v4 (resend)
Message-Id: <20090430140559.a2343f7c.akpm@linux-foundation.org>
In-Reply-To: <20090430014530.GB30287@cuplxvomd02.corp.sa.net>
References: <20090430014530.GB30287@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do sort out your email issues - this patchset came dribbled out
over a many-hour period with somewhat random cc's on each one, making
it all quite hard to discuss in any sensible way.

On Wed, 29 Apr 2009 18:45:30 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> This patch adds synchronization infrastructure between asynchronous device
> discovery and code that uses possibly asynchronous discovered devices at
> boot time. It provides the framework to fix race conditions, such as for
> the console, that have arisen as a result of quite successful work that has
> been done to reduce boot times.

Although I haven't read them yet, the patches themselves look very
nice - cleanly coded, carefully explained and well documented.  Easy to merge.

Unfortunately I don't know who you should have sent them to - nobody
really owns this stuff and it agglomerates over time as a result of
drive-by bandaiding by whoever happens to have a problem at the time.

I guess that means you should send them to me ;)

What would help things along here would be if you were to better
provide a description of what problem this all solves.  Presumably
there are scenarios where the kernel does something bad, and this
patchset fixes it.  Well, please describe some of these scenarios in
sufficient detail, and explain to us how the patch fixes them?

I'm a bit queazy over the whole "bootdev" name.  To me, a bootdev is
the storage device which we boot off: usually a spinning disk
containing grub.conf, bzImage, etc.    So I need to remember that

> +Boot devices are those devices that must be used or configured during the
> +boot process.

I wonder if we can think of something more new ad unique.  startupdev?  yuk.

Anyway, once we've settled upon an identifier for this patch series,
please religiously use it in all patches and emails which pertain to
the patchset.  So a good title for this email would have been

	bootdev: kernel: support asynchronously-discovered boot devices

etc.


So hum, what to do.  Please carefully address the changelog comments I
mentioned above (sell it to us!) then resend the patch series to

linux-kernel@vger.kernel.org
linux-usb@vger.kernel.org
netdev@vger.kernel.org
linux-scsi@vger.kernel.org
Andrew Morton <akpm@linux-foundation.org>
Greg KH <greg@kroah.com>
Arjan van de Ven <arjan@infradead.org>

and anyone else you can think of ;)

Once I have a vague understanding of what actual user-visible problems
the patchset solves, I'll probably merge it into my tree and after a
period of testing and review, I'd merge the core part(s) into mainline
and I'd then send the subsystem-specific parts (netdev, usb, scsi) into
the relevant maintainers of those trees.

Thanks.
