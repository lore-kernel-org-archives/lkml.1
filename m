Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXLXOO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXLXOO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLXOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:14:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXLXOOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:14:50 -0500
Date: Mon, 24 Dec 2007 06:12:20 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
Message-Id: <20071224061220.ceed2bf8.zaitcev@redhat.com>
In-Reply-To: <1198428397.2742.20.camel@imap.mvista.com>
References: <20071221205854.408865412@mvista.com>
	<20071221205859.316759032@mvista.com>
	<20071221222428.a75a5a34.zaitcev@redhat.com>
	<1198342910.2742.14.camel@imap.mvista.com>
	<20071222233733.3a4e94b0.zaitcev@redhat.com>
	<1198428397.2742.20.camel@imap.mvista.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 08:46:37 -0800, Daniel Walker <dwalker@mvista.com> wrote:

> I noticed you also have a spinlock held in usu_probe_thread(), the
> usu_lock.. That spinlock would preclude anything inside request_module()
> from sleeping..

The usu_lock is not held across request_module. In fact, it can be
easily taken from inside request_module, when it invokes modprobe.
Stop scaring me :-)

> One thing that has bothered me is that I don't see a reason why this
> couldn't become a complete, yet you have a comment which says that it
> can't be a complete.. I honestly didn't understand the comment.. I would
> imagine that you tried a complete , and it didn't work?

Yes, it was a completition initially. But suppose you have two storage
devices, plugged in across a reboot. Two threads are created and have to
wait until the libusual's init function ends. Since we post one completion,
only one thread continues.

-- Pete
