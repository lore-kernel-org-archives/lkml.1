Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXLWHkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXLWHkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXLWHkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:40:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXLWHj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:39:59 -0500
Date: Sat, 22 Dec 2007 23:37:33 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, zaitcev@redhat.com
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
Message-Id: <20071222233733.3a4e94b0.zaitcev@redhat.com>
In-Reply-To: <1198342910.2742.14.camel@imap.mvista.com>
References: <20071221205854.408865412@mvista.com>
	<20071221205859.316759032@mvista.com>
	<20071221222428.a75a5a34.zaitcev@redhat.com>
	<1198342910.2742.14.camel@imap.mvista.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 09:01:50 -0800, Daniel Walker <dwalker@mvista.com> wrote:

> Then in usu_probe_thread() your basically stopping it at the start of
> the function with a down(), and the up() is just ancillary .. So you
> could easily move the up() further down in the function and still have
> the same level of exclusion.. 

The unfortunate complication here is request_module. I didn't want to
keep a semaphore locked across it, in case child waits for something.
I wonder if there may be some deadlock that we cannot foresee.
But I guess it won't hurt to try.

I tested the patch and it seems to work ok.

-- Pete
