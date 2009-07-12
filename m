Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZGLVBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZGLVBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZGLVAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:00:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:51518 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZGLVAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:00:52 -0400
MIME-Version: 1.0
Message-ID: <675faabd-bc61-46ed-af91-d7b4d7db8d14@default>
Date: Sun, 12 Jul 2009 13:59:08 -0700 (PDT)
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
In-Reply-To: <4A5A1D15.1090809@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A5A4ED4.017B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > anonymous memory.  That larger scale "memory shaping" is left to
> > ballooning and hotplug.
> 
> And this is where the policy problems erupt.  When do you balloon in 
> favor of tmem?  which guest do you balloon? do you leave it to the 
> administrator? there's the host's administrator and the guests' 
> administrators.
> :
> CMM2 solves this neatly by providing information to the host. 

As with CMM2, ballooning is for larger scale memory shaping.
Tmem provides a safety valve if the shaping is too aggressive
(and thus encourages more aggressive ballooning).  So they
are complementary.  Tmem also provides plenty of information
to the host that can be used to fine tune ballooning policy
if desired (and this can be done in userland and/or management
tools).
 
> > I don't see that it gives up that flexibility.  System adminstrators
> > are still free to size their guests properly.  Tmem's contribution
> > is in environments that are highly dynamic, where the only
> > alternative is really sizing memory maximally (and thus wasting
> > it for the vast majority of time in which the working set 
> is smaller).
> 
> I meant that once a page is converted to tmem, there's a 
> limited amount 
> of things you can do with it compared to normal memory.  For example 
> tmem won't help with a dcache intensive workload.

Yes that's true.  But that's part of the point of tmem.  Tmem
isn't just providing benefits to a single guest.  It's
providing "memory liquidity" (Jeremy's term, but I like it)
which benefits the collective of guests on a machine and
across the data center.  For KVM+CMM2, I suppose this might be
less valuable because of the more incestuous relationship
between the host and guests.

> > I'm certainly open to identifying compromises and layer 
> modifications
> > that help meet the needs of both Xen and KVM (and others).  For
> > example, if we can determine that the basic hook placement for
> > precache/preswap (or even just precache for KVM) can be built
> > on different underlying layers, that would be great!
> 
> I'm not sure preswap/precache by itself justifies tmem since 
> it can be 
> emulated by backing the disk with a cached file.

I don't see that it can... though perhaps it can in the KVM
world.

> What I'm missing in 
> tmem is the ability for the hypervisor to take a global view 
> on memory; 
> instead it's forced to look at memory and tmem separately.  

Again, I guess I see this as one of the key values of tmem.
Memory *does* have different attributes and calling out the
differences in some cases allows more flexibility to the
whole collective of guests with very little impact to any
one guest.

P.S.  I have to mostly disconnect from this discussion for
a few days except for short replies.
