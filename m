Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbZHZOne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbZHZOne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZHZOnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:43:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56331 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZHZOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:43:32 -0400
Date: Wed, 26 Aug 2009 10:43:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
In-Reply-To: <20090826141052.GB5946@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.0908261043070.23885@gandalf.stny.rr.com>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere>
 <20090826141052.GB5946@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Aug 2009, Heiko Carstens wrote:
> > Ah, there are callsites that use kernel_thread() directly?
> > Does it means that t->mm could be non NULL for such resulting
> > kernel threads, in that case it would be hard to hook on
> > do_fork() to check that.
> 
> Oh yes, you are right. kernel threads created with kernel_thread()
> have t->mm != NULL if the forking process has an mm too.
> 
> There are very few callsites left which still use kernel_thread().
> (the last one in s390 driver code will be gone after the next
> merge window).
> 
> As far as I can there are only four callsites left
> (excluding staging): jffs2 and three in net/bluetooth/*

Ouch! Those need to be fixed.

Thanks,

-- Steve

