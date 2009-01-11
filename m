Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZAKWxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZAKWxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZAKWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:52:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:33771 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbZAKWwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:52:54 -0500
Date: Sun, 11 Jan 2009 23:52:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>
cc: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: Does CONFIG_PARAVIRT imply usage of byte locks?
In-Reply-To: <49693515.5000106@goop.org>
Message-ID: <alpine.LNX.1.10.0901112350580.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz> <49693515.5000106@goop.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Jeremy Fitzhardinge wrote:

> > Looking at the code, I wonder whether are we in fact really using byte 
> > locks in CONFIG_PARAVIRT situation? Where are we actually setting 
> > pv_lock_ops.spin_lock pointer to point to __byte_spin_lock?
> > 
> > Such initialization seems to happen only in paravirt_use_bytelocks()
> > function, but my blind eyes prevent me from finding a callsite from which
> > this function would eventually get called.
> > 
> > It seems to me that paravirt_use_bytelocks() is a dead code that gets never
> > called, and the same applies to the implementations of write locks. What did
> > I miss?
> 
> Probably nothing.  Xen has its own optimised spinlock implementation, and so
> doesn't use the plain byte locks.  But ticket locks are awesomely bad for any
> virtual environment which doesn't gang schedule VCPUs, so the kvm folks would
> do well to at least consider using them.

Avi, are there any plans to make KVM use byte locks implementation for 
spinlocks in the near future?

If not, we should remove them completely, as it's completely dead code.

Thanks,

-- 
Jiri Kosina
SUSE Labs
