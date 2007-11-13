Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbXKMSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbXKMSac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXKMSaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:30:24 -0500
Received: from rtr.ca ([76.10.145.34]:2908 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXKMSaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:30:23 -0500
Message-ID: <4739ED3C.6090809@rtr.ca>
Date: Tue, 13 Nov 2007 13:30:20 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Subject: Re: Oops 2.6.23.1 in ext3+jbd at journal_put_journal_head
References: <4738AC21.8070507@rtr.ca> <20071113172130.GA13733@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071113172130.GA13733@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hello,
> 
>> A one-time event thus far, happened under very heavy I/O,
>> Dell i9400 Core2Duo notebook w/3GB ram, single SATA drive with ext3.
>> Had to cycle power to get it back and see this Oops in the syslog:
..
>   Hmm, your pointer to buffer_head in journal_head has been overwritten
> by some garbage - it actually looks like ASCII ("C\n ra"). I think your
> journal_head pointer is stored in EAX (at least if I compile SMP kernel
> for i386 it is) and that is 0xc2bd7000 - start of the page. So probably
..

As for me, I'm guessing a use/free race somewhere, but with
only the information from the Oops that's hard to know.

> some driver went wild and overwritten a piece of memory which did not
> belong to it... I suggest turning on a few debugging options (like
> DEBUG_SLAB) to catch the offender.
..

You mean, like, this:

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.23.1-slab
> # Wed Nov  7 08:00:18 2007
> #
> CONFIG_X86_32=y 
...
> CONFIG_DEBUG_SLAB=y 
...

Thought since it was..

> A one-time event thus far ...
..

.. I'm unlikely to see it again.

Cheers
