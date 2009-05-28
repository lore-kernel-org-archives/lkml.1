Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbZE1Dtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbZE1Dtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZE1Dtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:49:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:37736 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZE1Dtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:49:46 -0400
MIME-Version: 1.0
Message-ID: <e5322423-6944-432f-911e-2f5beb18eaee@default>
Date: Wed, 27 May 2009 20:47:46 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, George Dunlap <George.Dunlap@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
In-Reply-To: <20090528001350.GD26820@elte.hu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A1E096B.017B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > The Linux scheduler already supports multiple scheduling 
> > > classes.  If we find that none of them will fit our needs, we'll 
> > > propose a new one.  When the need can be demonstrated to be 
> > > real, and the implementation can be clean, Linux can usually be 
> > > adapted.
> > 
> > But that's exactly George and Jeremy's point.  KVM will eventually 
> > require changes that clutter Linux for purposes that are relevant 
> > only to a hypervisor.
> 
> That's wrong. Any such scheduler classes would also help: control 
> groups, containers, vserver, UML and who knows what other isolation 
> project. Many of such mechanisms are already implemented as well.

I think you are missing the point.  Yes, certainly, generic
scheduler code can be written that applies to all of these
uses.  But will that be the same code that is best for KVM to
succeed in an enterprise-class virtual data center?
I agree with George that it will not; generic code and optimal
code are rarely the same thing.  What's best for an operating
system is not always what's best for a hypervisor.

But we are both speculating.  I guess only time will tell.

> I also find it pretty telling that you cut out the most important 
> point of Avi's reply:
> 
> > > I think the Xen design has merit if it can truly make dom0 a 
> > > guest -- that is, if it can survive dom0 failure.  Until then, 
> > > you're just taking a large interdependent codebase and splitting 
> > > it at some random point, but you don't get any stability or 
> > > security in return.
> 
> that crucial question really has to be answered honestly and 
> upfront.

I cut it out because I thought others would be more qualified
to answer, but since nobody else has, I will.  Absolutely there
is work going on to survive failure of dom0 (or any domain)!
This is a must for enterprise-grade availability and security,
such as is needed for huge corporate data centers and "clouds".
However, the majority of users (individuals and small businesses)
will probably be most happy with their distro (and distro kernel)
as dom0 since it is convenient and familiar.
