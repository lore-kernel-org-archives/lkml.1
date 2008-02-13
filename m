Return-Path: <linux-kernel-owner+w=401wt.eu-S1764365AbYBMP1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764365AbYBMP1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYBMP04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:26:56 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34887 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYBMP04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:26:56 -0500
Date: Wed, 13 Feb 2008 16:24:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Qemu & KVM bug
In-Reply-To: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802131621440.7699@twin.jikos.cz>
References: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Zdenek Kabelac wrote:

> I get this bug in my log whenever I start qemu-kvm - I do not use kqemu 
> module - so it's with plain kernel modules. If more details are needed - 
> just ask. (Cpu; C2D)
> BUG: sleeping function called from invalid context at kernel/rwsem.c:48
> in_atomic():1, irqs_disabled():0
> INFO: lockdep is turned off.
> Pid: 26600, comm: qemu-kvm Not tainted 2.6.25-rc1 #29

This has been obviously caused by Marcelo's (added to CC) commit 
10589a4699b, which added down_write(mmap_sem) to alloc_apic_access_page(), 
which is called with preempt disabled from vmx_create_vcpu().

-- 
Jiri Kosina
SUSE Labs

