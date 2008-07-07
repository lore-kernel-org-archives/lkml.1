Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYGGSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYGGSxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYGGSxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:53:42 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2705 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbYGGSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:53:41 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: "Michael Chan" <mchan@broadcom.com>
To: "David Woodhouse" <dwmw2@infradead.org>
cc: "Bastian Blank" <bastian@waldi.eu.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1215421413.3189.199.camel@shinybook.infradead.org>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
 <1215421413.3189.199.camel@shinybook.infradead.org>
Date: Mon, 07 Jul 2008 11:56:21 -0700
Message-ID: <1215456981.5532.20.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 646CB9A64E074486559-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 02:03 -0700, David Woodhouse wrote:
> The real concern I see would be if you make an incompatible change in
> the firmware when you add the new feature -- so that the older drivers
> would no longer work with the new firmware. But mostly, people don't
> do
> that -- I'm guessing that your planned new firmware should work just
> fine with older drivers, and the older drivers just won't use the new
> feature?
> 
> If it _is_ backward-incompatible, that's not really a problem. The
> solution is relatively simple; you just change the name of the
> firmware
> file that gets requested by the new driver -- so the old driver
> continues to request the old name, and get the firmware that works
> with
> it. It's a bit like an soname in userspace libraries, in that respect.

The driver is not guaranteed to be backward or forward compatible with
the firmware.  It may be forward compatible in most cases (new firmware
may work with older driver) but there is no guarantee because it is
simply not necessary in the current model.

We also only test 1 driver + 1 firmware and no other combinations.
Separating the 2 makes things more complicated and prone to random
failures.



