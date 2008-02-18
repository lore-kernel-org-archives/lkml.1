Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYBRNaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYBRNaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbYBRN3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:29:54 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62088 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760315AbYBRN3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:29:52 -0500
Date: Mon, 18 Feb 2008 14:29:49 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Haavard Skinnemoen" <hskinnemoen@norway.atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>, "David Brownell" <david-b@pacbell.net>,
       <kernel@avr32linux.org>, "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Message-ID: <20080218142949.2c5b2810@dhcp-252-066.norway.atmel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C0407A37A@orsmsx418.amr.corp.intel.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
	<20080213202402.22818482@siona>
	<20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com>
	<BAE9DCEF64577A439B3A37F36F9B691C0407A37A@orsmsx418.amr.corp.intel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 09:12:35 -0800
"Nelson, Shannon" <shannon.nelson@intel.com> wrote:

> I'll jump in here briefly - I'm okay with the direction this is going,
> but I want to be protective of ioatdma performance.  As used in struct
> ioat_desc_sw, the cookie and ack elements end up very close to the end
> of a cache line and I'd like them to not get pushed out across the
> boundry.  I don't think this proposal changes the layout, I'm just
> bringing up my concern.

Sure, performance is very important, and it's good to see that you're
critical about the changes I'm proposing. That said, the memory layout
doesn't change at all with this patch -- the fields that didn't go into
the generic dma descriptor were at the end of the struct to begin with.

I can add a comment saying that cookie and ack must always come first.
Any other fields that we need to be careful about?

Haavard
