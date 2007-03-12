Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXCLSgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXCLSgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXCLSgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:36:44 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:54508 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXCLSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:36:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Subject: BUG: atomic counter underflow at: page_add_file_rmap+0x41/0x50
Date: Tue, 13 Mar 2007 05:36:37 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <48f7fe350703120901y6c19c67v267ac2acd518a754@mail.gmail.com> <48f7fe350703121003p5fac23a1m32c3027d35a78cc2@mail.gmail.com>
In-Reply-To: <48f7fe350703121003p5fac23a1m32c3027d35a78cc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130536.37992.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 04:03, Ryan Hope wrote:
> I applied the detect-atomic-underflow patch and now I get these BUGs:
>
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
> BUG: atomic counter underflow at:
>  [<78167931>] page_add_file_rmap+0x41/0x50
>  [<78161c7d>] __handle_mm_fault+0x53d/0x900
>  [<78106de0>] do_IRQ+0x40/0x80
>  [<7811ff99>] do_page_fault+0x129/0x630
>  [<7811fe70>] do_page_fault+0x0/0x630
>  [<784907f4>] error_code+0x7c/0x84
>  [<78490000>] rt_mutex_slowunlock+0x160/0x1c0
>  =======================
>
> On 3/12/07, Ryan Hope <rmh3093@gmail.com> wrote:
> > I am currently running RSDL v0.30 on 2.6.21-rc2-mm2. I get these (what
> > seem to me as random) bug messages from dmesg; they are non fatal. I'm
> > not quite sure if this bug is a result of changes I have made on top of
> > RSDL; is this because of bad code I introduced or is the code that I
> > introduced exposing a bug in RSDL? The BUGs from dmesg are shown below.
> > If you need more info let me know.
> >

Not an RSDL bug, thanks.

-- 
-ck
