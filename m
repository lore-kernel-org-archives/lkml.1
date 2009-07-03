Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZGCSKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZGCSKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZGCSKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:10:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbZGCSKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:10:19 -0400
Date: Fri, 3 Jul 2009 11:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090703111016.ceb28541.akpm@linux-foundation.org>
In-Reply-To: <6599ad830907031054x74d90149y38aae60afa403d58@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	<20090702190845.0cafc46a.akpm@linux-foundation.org>
	<6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	<20090702235527.7ddc873c.akpm@linux-foundation.org>
	<6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
	<20090703095000.cf46ad19.akpm@linux-foundation.org>
	<6599ad830907031054x74d90149y38aae60afa403d58@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 10:54:48 -0700 Paul Menage <menage@google.com> wrote:

> >__Unfortunately radix-trees are presented as operating on
> > void* data, so one would need to do some typecasting when storing
> > BITS_PER_LONG-sized bitfields inside them.
> 
> That would mean adding something a bit like the IDA wrapper that
> converts IDR to deal with bitfields?

I guess so.

> Is the benefit of avoiding a vmalloc() at all costs really worth the
> additional complexity

Well no.  But nor was it worth the additional complexity the last twenty
times someone resorted to vmalloc to solve a problem of this nature.  Taking
a kernel-wide perspective here gives a different answer.

However I don't think a little scoreboarding thing (what's the correct
term) built around radix-trees would suffice to solve many of those
past sins.  Whereas a general dynamic array thing would be applicable
in many cases.
