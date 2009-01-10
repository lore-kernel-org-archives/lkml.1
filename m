Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZAJXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZAJXyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZAJXyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:54:06 -0500
Received: from gw.goop.org ([64.81.55.164]:46808 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJXyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:54:04 -0500
Message-ID: <49693515.5000106@goop.org>
Date: Sun, 11 Jan 2009 10:53:57 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: Does CONFIG_PARAVIRT imply usage of byte locks?
References: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Hi,
>
> in [1] Linus states that CONFIG_PARAVIRT implies usage of inferior locks.
>   

Yes, he's wrong about that.  In the normal case, the CONFIG_PARAVIRT 
case will continue to use the ticket-lock algorithm.

> Looking at the code, I wonder whether are we in fact really using byte 
> locks in CONFIG_PARAVIRT situation? Where are we actually setting 
> pv_lock_ops.spin_lock pointer to point to __byte_spin_lock?
>
> Such initialization seems to happen only in paravirt_use_bytelocks()
> function, but my blind eyes prevent me from finding a callsite from which
> this function would eventually get called.
>
> It seems to me that paravirt_use_bytelocks() is a dead code that gets 
> never called, and the same applies to the implementations of write locks. 
> What did I miss?
>   

Probably nothing.  Xen has its own optimised spinlock implementation, 
and so doesn't use the plain byte locks.  But ticket locks are awesomely 
bad for any virtual environment which doesn't gang schedule VCPUs, so 
the kvm folks would do well to at least consider using them.

    J
