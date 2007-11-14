Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbXKNACE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbXKNACE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXKNABw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:01:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbXKNABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:01:52 -0500
Date: Tue, 13 Nov 2007 16:01:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 22/54] kset: convert /sys/devices/system to use
 kset_create
Message-Id: <20071113160144.18f3d45a.akpm@linux-foundation.org>
In-Reply-To: <20071113151410.b5c989dd.akpm@linux-foundation.org>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-22-git-send-email-gregkh@suse.de>
	<20071105191109.52c07ab4@gondolin.boeblingen.de.ibm.com>
	<20071105185828.GA31896@suse.de>
	<20071105201132.3a3e443b@gondolin.boeblingen.de.ibm.com>
	<20071105200334.GA25947@suse.de>
	<20071113151410.b5c989dd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 15:14:10 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 5 Nov 2007 12:03:34 -0800 Greg KH <gregkh@suse.de> wrote:
> 
> > > > >     <4> [<0000000000142548>] sys_reboot+0x1a4/0x1f4
> > > > >     <4> [<0000000000111038>] sysc_noemu+0x10/0x16
> > > > >     <4> [<00000200001048e0>] 0x200001048e0
> > > > >     <4>
> > > > >     <4> 
> > > > > 
> > > > > Huh? We want to shutdown an unknown device on a bus that wishes to stay
> > > > > anonymous?
> > > > > 
> > > > > Any hints would be appreciated...
> > > > 
> > > > I'll look into this, I wonder if we are walking off the end of an
> > > > unterminated list...
> > > 
> > > Could well be. If I'm using lcrash's walk function correctly (which
> > > always manages to confuse me...), the list of devices_kset seems to be
> > > broken.
> > 
> > Alright, I can reproduce something like this at shutdown time myself
> > here, I'll try to figure it out...
> 
> <wishes he'd read this thread an hour ago>
> 
> The Vaio oopses during `reboot -f' and I bisected it down to this patch.
> 
> http://userweb.kernel.org/~akpm/dsc00034.jpg
> http://userweb.kernel.org/~akpm/config-sony.txt
> http://userweb.kernel.org/~akpm/dmesg-sony.txt

The G5 Mac oopses in the same place during `halt -pfn'.
