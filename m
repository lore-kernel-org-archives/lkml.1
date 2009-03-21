Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZCUPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZCUPBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZCUPBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:01:09 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:46345 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbZCUPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:01:08 -0400
Date: Sat, 21 Mar 2009 16:01:02 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace/ring_buffer: fix section mismatch warning
Message-ID: <20090321160102.7b5a9675@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090321143911.GA25729@elte.hu>
References: <20090321124139.4ca216d9@osiris.boeblingen.de.ibm.com>
	<20090321143911.GA25729@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 15:39:11 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > Section mismatch in reference from the function 
> > ring_buffer_alloc() to the function .cpuinit.text:rb_cpu_notify() 
> > The function ring_buffer_alloc() references the function __cpuinit 
> > rb_cpu_notify(). This is often because ring_buffer_alloc lacks a 
> > __cpuinit annotation or the annotation of rb_cpu_notify is wrong.
> > 
> > This is a false positive since rb_cpu_notify gets only referenced 
> > if CONFIG_HOTPLUG_CPU=y. To get rid of the warning annotate 
> > ring_buffer_alloc with __ref.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  kernel/trace/ring_buffer.c |    2 +-
> 
> Frederic has beaten you to it narrowly:
> 
> 09c9e84: tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit

Btw. that was the only section mismatch warning I got on linux-next
with an allyesconfig on s390. We probably could enable the verbose
section mismatch warnings at compile time?

Sam?
