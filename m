Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGLQbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGLQbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 12:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZGLQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 12:30:54 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:54641 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZGLQax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 12:30:53 -0400
MIME-Version: 1.0
Message-ID: <426e84ca-be31-40ac-a4c1-42cd9677d86c@default>
Date: Sun, 12 Jul 2009 09:28:38 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
In-Reply-To: <4A59AAF1.1030102@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A5A0F6E.017F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That 63GB requires no page structs or other data structures in the
> > guest.  And in the current (external) implementation, the size
> > of each pool is constantly changing, sometimes dramatically so
> > the guest would have to be prepared to handle this.  I also wonder
> > if this would make shared-tmem-pools more difficult.  
> 
> Having no struct pages is also a downside; for example this 
> guest cannot 
> have more than 1GB of anonymous memory without swapping like mad.  
> Swapping to tmem is fast but still a lot slower than having 
> the memory 
> available.

Yes, true.  Tmem offers little additional advantage for workloads
that have a huge variation in working set size that is primarily
anonymous memory.  That larger scale "memory shaping" is left to
ballooning and hotplug.

> tmem makes life a lot easier to the hypervisor and to the guest, but 
> also gives up a lot of flexibility.  There's a difference 
> between memory 
> and a very fast synchronous backing store.

I don't see that it gives up that flexibility.  System adminstrators
are still free to size their guests properly.  Tmem's contribution
is in environments that are highly dynamic, where the only
alternative is really sizing memory maximally (and thus wasting
it for the vast majority of time in which the working set is smaller).

> > I can see how it might be useful for KVM though.  Once the
> > core API and all the hooks are in place, a KVM implementation of
> > tmem could attempt something like this.
> >    
> 
> My worry is that tmem for kvm leaves a lot of niftiness on the table, 
> since it was designed for a hypervisor with much simpler memory 
> management.  kvm can already use spare memory for backing guest swap, 
> and can already convert unused guest memory to free memory 
> (by swapping 
> it).  tmem doesn't really integrate well with these capabilities.

I'm certainly open to identifying compromises and layer modifications
that help meet the needs of both Xen and KVM (and others).  For
example, if we can determine that the basic hook placement for
precache/preswap (or even just precache for KVM) can be built
on different underlying layers, that would be great!

Dan
