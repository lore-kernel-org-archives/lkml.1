Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbXB0BxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbXB0BxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXB0BxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:53:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:18410 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbXB0BxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:53:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,222,1170662400"; 
   d="scan'208"; a="50910913:sNHT20990583"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Date: Mon, 26 Feb 2007 17:57:11 -0800
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070227001338.344233745@sodium.jf.intel.com> <200702261654.18005.inaky@linux.intel.com> <20070227021803.38c8591f@lxorguk.ukuu.org.uk>
In-Reply-To: <20070227021803.38c8591f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261757.11968.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 February 2007 18:18, Alan wrote:
> > Yeah, I need semaphore. This is a hw register that says when the hw
> > is ready to accept a new command. Code that wants to send commands has
> > to down the semaphore and then send it. When hw is ready to get a new
> > command, it sends and IRQ and the IRQ up()s the semaphore.
>
> So you need a mutex not a semaphore

Theoretically I could use a mutex. Practically it would trigger ugly
complications. Only the owner can unlock a mutex (for example), so
I could not unlock from an IRQ handler -- not to mention that the
semantic rules outlined in Documentation/mutex-design.txt explicitly
forbid IRQ usage. 

And then, this is what semaphores where designed for, as gates :)
for once that I get to use a semaphore properly...
