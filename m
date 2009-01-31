Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZAaV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZAaV2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZAaV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:28:40 -0500
Received: from movementarian.org ([79.99.65.163]:53626 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZAaV2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:28:39 -0500
Date: Sat, 31 Jan 2009 16:28:32 -0500
From: wli@movementarian.org
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup macros
Message-ID: <20090131212832.GB26410@movementarian.org>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain> <20090131045733.GA26410@movementarian.org> <alpine.DEB.1.10.0901311104180.18888@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901311104180.18888@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, wli@movementarian.org wrote:
>> The filtered wakeup code uses some notion of a key already. There, the
>> key is to route wakeups to recipients associated with the correct
>> object. Here, the objects are known in advance. The wakeup is to give
>> them some particular message in which they may not necessarily be
>> interested. Names indicative of that (e.g. *_msg/msg_*) would clarify
>> the distinction between it and the filtered wakeup code used for pages.

On Sat, Jan 31, 2009 at 11:08:40AM -0800, Davide Libenzi wrote:
> I had thought of giving the void* some structure, besides being a cast 
> from an event mask, so that later on we'd be able to eventually embed 
> more information in the wakeup. Dunno if worth it.

kernel/wait.c uses struct wait_bit_key; void * was merely for keeping it
as private as possible, though it is exposed for the sake of macros like
DEFINE_WAIT_BIT et al. It would make little difference to the pagecache
waitqueue code if the structure were augmented, the function prototypes
changed to reflect the argument type, etc. There are a priori guarantees
based on the objects that the lists of tasks considered won't overlap,
so unrelated structures are even possible.


-- wli
