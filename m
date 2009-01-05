Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZAECtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZAECtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZAECtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:49:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:60294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZAECtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:49:12 -0500
Date: Sun, 4 Jan 2009 18:51:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Message-ID: <20090104185103.06e2f531@infradead.org>
In-Reply-To: <1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104093103.46167d23@infradead.org>
	<1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
	<20090104175830.7a7e279e@infradead.org>
	<1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 10:51:50 +0800
Zhao Yakui <yakui.zhao@intel.com> wrote:

> > because of the async_synchronize_cookie() call!
> After the async_synchronize_cookie is called, the register sequence
> will become strict. 
> But there exist multiple threads. It is possible that the function of
> acpi_bus_register_async is called on different threads. In such case
> the dependency can't be guaranteed. 

this is not correct.
when the async_synchronize_cookie() call returns, all previous
acpi_bus_register_async() calls have completed. So no older ones can be
running.

there also can be no newer ones, because newer ones will wait for the
current one to entirely complete before they will return from
acpi_bus_register_async()

so.. since all older ones are complete, and no new ones can happen..
the sequence is strictly followed.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
