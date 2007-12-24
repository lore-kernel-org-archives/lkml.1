Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbXLXQFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbXLXQFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 11:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXLXQFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 11:05:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:20855 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXLXQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 11:05:40 -0500
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
From: Daniel Walker <dwalker@mvista.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
In-Reply-To: <20071224061220.ceed2bf8.zaitcev@redhat.com>
References: <20071221205854.408865412@mvista.com>
	 <20071221205859.316759032@mvista.com>
	 <20071221222428.a75a5a34.zaitcev@redhat.com>
	 <1198342910.2742.14.camel@imap.mvista.com>
	 <20071222233733.3a4e94b0.zaitcev@redhat.com>
	 <1198428397.2742.20.camel@imap.mvista.com>
	 <20071224061220.ceed2bf8.zaitcev@redhat.com>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 08:04:08 -0800
Message-Id: <1198512248.2742.31.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-24 at 06:12 -0800, Pete Zaitcev wrote:
> On Sun, 23 Dec 2007 08:46:37 -0800, Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I noticed you also have a spinlock held in usu_probe_thread(), the
> > usu_lock.. That spinlock would preclude anything inside request_module()
> > from sleeping..
> 
> The usu_lock is not held across request_module. In fact, it can be
> easily taken from inside request_module, when it invokes modprobe.
> Stop scaring me :-)

Your right, it's just outside .. I still don't think it could deadlock,
since I don't see a code path to recursively get back into those
libusual functions..

> > One thing that has bothered me is that I don't see a reason why this
> > couldn't become a complete, yet you have a comment which says that it
> > can't be a complete.. I honestly didn't understand the comment.. I would
> > imagine that you tried a complete , and it didn't work?
> 
> Yes, it was a completition initially. But suppose you have two storage
> devices, plugged in across a reboot. Two threads are created and have to
> wait until the libusual's init function ends. Since we post one
> completion,
> only one thread continues.

Ok .. The mutex should just prevent them from running at the same time,
but they should both run eventually.

Daniel

