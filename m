Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0CJDNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:13:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:42854 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755925Ab0CJDNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:13:32 -0500
Date: Tue, 9 Mar 2010 22:13:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <d9def9db1003091532icb671efy48b30185b86effcb@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1003092209160.29607-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Markus Rechberger wrote:

> On Tue, Mar 9, 2010 at 11:31 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 9 Mar 2010, Markus Rechberger wrote:
> >
> >> Hi,
> >>
> >> I just stumbled around following issue:
> >>
> >> [275835.163502] Pid: 14298, comm: mediasrv Not tainted 2.6.33 #7
> >> [275835.163505] Call Trace:
> >> [275835.163514]  [<ffffffff810df7a6>] __alloc_pages_nodemask+0x5b6/0x700
> >> [275835.163520]  [<ffffffff8110c667>] alloc_pages_current+0x87/0xd0
> >> [275835.163525]  [<ffffffff810dcf79>] __get_free_pages+0x9/0x50
> >> [275835.163529]  [<ffffffff81114f2b>] __kmalloc+0x13b/0x1f0
> >> [275835.163535]  [<ffffffff813a18ef>] proc_do_submiturb+0x2ff/0x9d0
> >> [275835.163539]  [<ffffffff813a26b9>] usbdev_do_ioctl+0x6f9/0x14a0
> >
> > The mediasrv program tried to allocate more memory than was available.
> > It's unfortunate but it's not a bug.
> >
> 
> Yes, 'unfortunate' is what bothers me about this, it can only be
> around 198kbyte what the app can try to request (everything else will
> fail internally).
> The system has 4 gig ram, around 1 gig was not allocated (according to
> free). not sure but I guess the pool where kmalloc tried to get the
> memory from was out of memory, at least the OOM manager was not active
> at all either and the rest of the system was more or less running
> smoothly at this time.

I suppose it's barely possible that even though 1 GB of memory was
free, there was too much fragmentation to allocate a contiguous 198 KB
buffer.  But that seems rather unlikely (unless your machine had been
up for a very long time).

At any rate, clearly the bug, if there is one, lies in the memory
management subsystem and not in usbfs.

Alan Stern

