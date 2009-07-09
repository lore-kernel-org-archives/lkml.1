Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZGIVu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZGIVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZGIVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:50:20 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:36943 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbZGIVuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:50:19 -0400
MIME-Version: 1.0
Message-ID: <fa083462-f28d-4188-9006-a285141acc21@default>
Date: Thu, 9 Jul 2009 14:48:10 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
In-Reply-To: <4A5660CB.5080607@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A5665CF.0080:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not saying either one is bad or good -- and I'm sure
> > each can be adapted to approximately deliver the value
> > of the other -- they are just approaching the same problem
> > from different perspectives.
> 
> Indeed.  Tmem and auto-ballooning have a simple mechanism,
> but the policy required to make it work right could well
> be too complex to ever get right.
> 
> CMM2 has a more complex mechanism, but the policy is
> absolutely trivial.

Could you elaborate a bit more on what policy you
are referring to and what decisions the policies are
trying to guide?  And are you looking at the policies
in Linux or in the hypervisor or the sum of both?

The Linux-side policies in the tmem patch seem trivial
to me and the Xen-side implementation is certainly
working correctly, though "working right" is a hard
objective to measure.  But depending on how you define
"working right", the pageframe replacement algorithm
in Linux may also be "too complex to ever get right"
but it's been working well enough for a long time.

> CMM2 and auto-ballooning seem to give about similar
> performance gains on zSystem.

Tmem provides a huge advantage over my self-ballooning
implementation, but maybe that's because it is more
aggressive than the CMM auto-ballooning, resulting
in more refaults that must be "fixed".

> I suspect that for Xen and KVM, we'll want to choose
> for the approach that has the simpler policy, because
> relying on different versions of different operating
> systems to all get the policy of auto-ballooning or
> tmem right is likely to result in bad interactions
> between guests and other intractable issues.

Again, not sure what tmem policy in Linux you are referring
to or what bad interactions you foresee.  Could you
clarify?

Auto-ballooning policy is certainly a challenge, but
that's true whether CMM or tmem, right?

Thanks,
Dan
