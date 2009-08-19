Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbZHSKwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbZHSKwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZHSKwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:52:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55933 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbZHSKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:52:46 -0400
Date: Wed, 19 Aug 2009 11:53:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, dhowells@redhat.com,
       Kumar Gala <galak@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: spin_is_locked() broken for uniprocessor?
Message-ID: <20090819115301.563be6da@lxorguk.ukuu.org.uk>
In-Reply-To: <7099.1250674686@redhat.com>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
	<DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
	<7099.1250674686@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 10:38:06 +0100
David Howells <dhowells@redhat.com> wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > which implies to me that spin_is_locked() will always return false.  Is this
> > > expected behavior.
> > 
> > That's wrong. spin_is_locked should always return true on UP.
> 
> Surely it's not that simple?  Maybe spin_is_lock() should be undefined on UP.

That would lead to a lot of

#ifdef CONFIG_SMP

#endif

in drivers because there is driver code that uses spin_is_locked() in
fairly sensible fashion when dealing with locking.
