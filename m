Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYC0KVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYC0KVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYC0KVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:21:22 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50531 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322AbYC0KVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:21:22 -0400
Date: Thu, 27 Mar 2008 11:20:48 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com, lethal@linux-sh.org,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080327112048.014200cb@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <bc64b4640803270308w6dc0723dr29e0ce5f20088d6d@mail.gmail.com>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
	<20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	<bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	<20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	<20080327091810.GA32396@flint.arm.linux.org.uk>
	<20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com>
	<20080327093301.GB32396@flint.arm.linux.org.uk>
	<20080327105323.28a369fd@hskinnemo-gx620.norway.atmel.com>
	<bc64b4640803270308w6dc0723dr29e0ce5f20088d6d@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 10:20:49.0036 (UTC) FILETIME=[3A2514C0:01C88FF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 13:08:37 +0300
Dmitry <dbaryshkov@gmail.com> wrote:

> I like this idea! This would also allow to cleanup the references code, etc.

Great!

> Also after I saw such refactored struct clk, I thought that it looks
> nearly like kobject. Maybe we should switch to the kobject-based
> structs? What do you think?

I think that would be overkill. We should try to keep this stuff as
lightweight as possible, and I'm not sure if we can give the kobject
"parent" field the meaning we want it to have...or use the kref thing
to do something unrelated to object lifecycle management (i.e. we don't
want to destroy the object when the refcount goes to zero, we just want
to stop the clock.)

Haavard
