Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYLONrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYLONrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYLONri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:47:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYLONri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:47:38 -0500
Date: Mon, 15 Dec 2008 08:47:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: local_add_return
Message-ID: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I'm trying to make the ring buffers lockless and reentrant. It is slowly 
going that way. The local_add_return is to reserve a part of the ring 
buffer even when an interrupt can come in and reserver part of that same 
ring buffer. The atomic add here has to only be atomic with respect to 
interrupts.

On intel, there is no reason to use a LOCK increment, since the ring 
buffers are per cpu. A simple asm inc would work. I was thinking that is 
what local_add_return gives me. I could replace the local_add_returns with 
atomic_add_return, but that just seems to be adding overhead for archs 
that do not need it.

Shouldn't local_add_return be a way for archs that can increment a memory 
location atomically against interrupts to use that infrastructure? It can 
simply fall back to atomic_add_return for those archs that do not have 
a lesser equivalent of atomic_add_return.

-- Steve


