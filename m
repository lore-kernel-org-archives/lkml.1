Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYBGRxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYBGRxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYBGRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:53:00 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53670 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755664AbYBGRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:52:59 -0500
Date: Thu, 7 Feb 2008 18:52:52 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Message-ID: <20080207185252.398eb171@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802061046r2d939947m97883c3fbef6e016@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<20080129215453.1e3758ab@siona>
	<200801292256.14553.david-b@pacbell.net>
	<20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20801300939w7b73f5a6ld73bde8c3fada569@mail.gmail.com>
	<20080204163200.550481a7@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20802061046r2d939947m97883c3fbef6e016@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 11:46:43 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> > The client must somehow know when the transfer is complete -- after
> > all, it has to call async_tx_ack() at some point. So additional
> > callbacks shouldn't be needed.
> >  
> 
> The 'ack' only signifies that the client is done with this descriptor,
> it tells the api "this descriptor can be freed/reused, no dependent
> operations will be submitted against it".  This can and does happen
> before the operation actually completes.

Hmm...ok. But at some point, the client must know that the buffer is
completely filled with valid data so that it can call some kind of
operation_foo_finish() function to do the necessary unmapping...

> > This requires three additional fields in the dma_async_tx_descriptor
> > structure, but in many cases the driver needs these fields in its own
> > private descriptor wrapper anyway.
> >  
> 
> I agree this should be moved up to the common descriptor.  The unmap
> routines are fairly symmetric, so it may not be that bad to also have
> an "unmap type" that the cleanup routines could key off of, one of the
> options being "do not unmap" for clients that know what they are
> doing.

I'd prefer that all clients know what they are doing ;-)

Haavard
