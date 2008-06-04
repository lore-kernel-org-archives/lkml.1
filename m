Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYFDO1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYFDO1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYFDO1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:27:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbYFDO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:27:23 -0400
Date: Wed, 4 Jun 2008 10:19:58 -0400
From: Dave Jones <davej@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NFS oops in 2.6.26rc4
Message-ID: <20080604141958.GA14148@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com> <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost> <20080530190314.GC32480@redhat.com> <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 03:37:01PM -0400, Chuck Lever wrote:
 
 > > Something else of note which I hadn't seen before, usually things lock
 > > up just after that first oops. For some reason, today it survived
 > > a little longer, but things really went downhill fast.
 > > It survived a 'dmesg ; scp dmesg davej@gelk', and then wedged solid.
 > > So as well as the oops, it seems we're corrupting memory too.
 > > For reference, this kernel has both SLUB_DEBUG and PAGEALLOC_DEBUG  
 > > enabled.
 > 
 > I haven't seen this kind of problem here with .26, but yes, it does  
 > look like something is clobbering memory during an NFS mount.
 > 
 > I introduced some NFS mount parsing changes in this commit range:
 > 
 >    2d767432..82d101d5
 > 
 > A quick bisect should show which, if any of these, is the guilty  
 > party.  If any of these are the problem, I suspect it's 3f8400d1.

I didn't get time to try this out yet (hopefully tomorrow).
In the meantime, we've just gotten word of another user seeing memory
corruption with nfs - https://bugzilla.redhat.com/show_bug.cgi?id=449958

	Dave

-- 
http://www.codemonkey.org.uk
