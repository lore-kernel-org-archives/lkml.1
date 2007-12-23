Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbXLWQru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbXLWQru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 11:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXLWQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 11:47:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:24389 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbXLWQrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 11:47:41 -0500
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
From: Daniel Walker <dwalker@mvista.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
In-Reply-To: <20071222233733.3a4e94b0.zaitcev@redhat.com>
References: <20071221205854.408865412@mvista.com>
	 <20071221205859.316759032@mvista.com>
	 <20071221222428.a75a5a34.zaitcev@redhat.com>
	 <1198342910.2742.14.camel@imap.mvista.com>
	 <20071222233733.3a4e94b0.zaitcev@redhat.com>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 08:46:37 -0800
Message-Id: <1198428397.2742.20.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-22 at 23:37 -0800, Pete Zaitcev wrote:
> On Sat, 22 Dec 2007 09:01:50 -0800, Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Then in usu_probe_thread() your basically stopping it at the start of
> > the function with a down(), and the up() is just ancillary .. So you
> > could easily move the up() further down in the function and still have
> > the same level of exclusion.. 
> 
> The unfortunate complication here is request_module. I didn't want to
> keep a semaphore locked across it, in case child waits for something.
> I wonder if there may be some deadlock that we cannot foresee.
> But I guess it won't hurt to try.

I noticed you also have a spinlock held in usu_probe_thread(), the
usu_lock.. That spinlock would preclude anything inside request_module()
from sleeping..

One thing that has bothered me is that I don't see a reason why this
couldn't become a complete, yet you have a comment which says that it
can't be a complete.. I honestly didn't understand the comment.. I would
imagine that you tried a complete , and it didn't work?

> I tested the patch and it seems to work ok.

Great, thanks ..

Daniel

