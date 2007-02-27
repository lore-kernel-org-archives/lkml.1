Return-Path: <linux-kernel-owner+w=401wt.eu-S1751340AbXB0AuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbXB0AuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXB0AuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:50:11 -0500
Received: from mga07.intel.com ([143.182.124.22]:44307 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbXB0AuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:50:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,222,1170662400"; 
   d="scan'208"; a="187458263:sNHT106453333"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Date: Mon, 26 Feb 2007 16:54:17 -0800
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070227001338.344233745@sodium.jf.intel.com> <20070227003313.GA7360@infradead.org>
In-Reply-To: <20070227003313.GA7360@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261654.18005.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 February 2007 16:33, Christoph Hellwig wrote:
> On Mon, Feb 26, 2007 at 04:13:38PM -0800, inaky@linux.intel.com wrote:
> > Introduce down_interruptible_timeout() using timers to make the waiter
> > stop waiting by simulating a signal (see first patch for more
> > details). As well introduce asm-generic/semaphore.h and make other
> > architectures use it too.
>
> What do you want this for?  Do you really need a full counting semaphore
> or do you actually want a mutex?

Yeah, I need semaphore. This is a hw register that says when the hw
is ready to accept a new command. Code that wants to send commands has
to down the semaphore and then send it. When hw is ready to get a new
command, it sends and IRQ and the IRQ up()s the semaphore. 

Now, we don't want to hang on that down() forever if the hw spaces out.
If we get a timeout, we can try recovery actions (like resetting it,
for sake of being polite). 

I use this in the WHCI Ultra Wide Band radio controller code (coming soon
to a hw store near you).

Cristoph, I still wonder how the hell you do it to spot every message
that comes into lkml -- I bet you have a cluster of employees using your
name doing it... :)

-- Inaky
