Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbZFRR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbZFRR6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZFRR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:58:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:37817 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZFRR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:58:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 18 Jun 2009 10:52:24 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <20090618062301.GA11155@redhat.com>
Message-ID: <alpine.DEB.1.10.0906181047040.32646@makko.or.mcafeemobile.com>
References: <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com>
 <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com> <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
 <20090618062301.GA11155@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Michael S. Tsirkin wrote:

> On Wed, Jun 17, 2009 at 04:21:19PM -0700, Davide Libenzi wrote:
> > The interface is just ugly IMO. You have eventfd_signal() that can sleep, 
> > or not, depending on the registered ->signal() function implementations.
> > This is pretty bad, a lot worse than the theoretical us spent in the 
> > schedule_work() processing.
> 
> I agree. How about the idea of introducing eventfd_signal_from_task
> which can sleep? Does this sound same?

You're basically asking to double the size of eventfd, make the signal 
path heavier, make the eventf size bigger, w/out having provided any *real 
life* measurement whatsoever to build a case for it.
WAY too much stuff went in by just branding the latest coolest names as 
reasons for them.
And all this to remove the wakeup of a *kernel* thread going to run in the 
same CPU where the work has been scheduled.
Come back with *replicable* real life benchmarks, and then we'll see what 
the best approach to address it will be.



- Davide


