Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYLDPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYLDPpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYLDPov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:44:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbYLDPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:44:47 -0500
Date: Thu, 4 Dec 2008 10:44:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
In-Reply-To: <1228405291.13111.86.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0812041044250.19693@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org>  <20081204052735.175697908@goodmis.org> <m1d4g8un6b.fsf@frodo.ebiederm.org>  <1228395378.13111.23.camel@nimitz> <1228396022.13111.27.camel@nimitz>  <m1prk8t5xr.fsf@frodo.ebiederm.org>
 <1228405291.13111.86.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Dave Hansen wrote:
> > 
> > We probably should.  Historically read_lock(&tasklist_lock) implies
> > rcu_read_lock().  And the tasklist lock is what we hold when it is
> > safe.
> 
> So, Dipankar tells me that you really do need rcu_read_lock/unlock() for
> the guarantee here; the tasklist lock is not sufficient.  The realtime
> kernel will preempt even those sections covered by spinlocks.

Yes it will.

-- Steve

