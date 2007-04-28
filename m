Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXD1Etb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXD1Etb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXD1Etb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:49:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965427AbXD1Eta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:49:30 -0400
Date: Fri, 27 Apr 2007 21:49:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: commit 45cd8d8e -- why?
Message-Id: <20070427214923.74c504d9.akpm@linux-foundation.org>
In-Reply-To: <ada647hnrf8.fsf@cisco.com>
References: <ada647hnrf8.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 19:50:19 -0700 Roland Dreier <rdreier@cisco.com> wrote:

> The changelog says:
> 
>     fs/sysfs/bin.c: In function 'read':
>     fs/sysfs/bin.c:77: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'int'
> 
> but the signature of the function read() is
> 
>     read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
> 
> and git blame seems to show it was always thus -- ie count was always size_t.
> 
> And now on x86-64 and ia64 with gcc 4.1 at least, I get:
> 
>     fs/sysfs/bin.c: In function 'read':
>     fs/sysfs/bin.c:62: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Some patches landed out of order.  In Greg's tree (with Tejun's patches)
`count' is a local variable (not an incoming arg) of type `int'.

So this patch was against Tejun's stuff, not against mainline.

I'd have picked that up, but I went and assumed that it was a victim of the
new dev_dbg() printk arg checking stuff.  Ho hum.

