Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbXJXTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbXJXTnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXJXTnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:43:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:49084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbXJXTnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:43:09 -0400
To: Ram <vshrirama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel processes - are they really needed?
From: Andi Kleen <andi@firstfloor.org>
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
Date: Wed, 24 Oct 2007 21:43:07 +0200
In-Reply-To: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com> (Ram's message of "Wed\, 24 Oct 2007 19\:07\:02 +0530")
Message-ID: <p73hckgqoxg.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram <vshrirama@gmail.com> writes:

> Hi,
>     When i do ps -l. i see the following processes which are obviously
> started by kernel.
>
>    Could any one tell me what each of these processes do 

> and can anyone of them can be removed.?

Some of them can probably. Or rather many depending on the configuration.

Sometimes there are good reasons for an own thread, but often there are also 
bad reasons.

If the threads don't sleep or have special requirements long they
should generally just use keventd instead.

Unfortunately a lot of people seem to think they're cheap because 
it's relatively easy to create them using work queues now, so we end
up with more and more all the time.

Especially on systems with many cores or threads which end up with a
lot of dubious per CPU threads. Some scaling up is needed, but one per CPU 
seems to be generally too many.

My favourite for a ridiculous thread was and is "kpsmoused" 

-Andi
