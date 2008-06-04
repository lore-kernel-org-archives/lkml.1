Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYFDSOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYFDSOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYFDSOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:14:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39569 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYFDSOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:14:34 -0400
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <E1135064-06EA-405C-A967-DFB1DC9F0418@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Dave Jones <davej@redhat.com>
In-Reply-To: <20080604141958.GA14148@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: NFS oops in 2.6.26rc4
Date: Wed, 4 Jun 2008 14:13:08 -0400
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com> <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost> <20080530190314.GC32480@redhat.com> <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com> <20080604141958.GA14148@redhat.com>
X-Mailer: Apple Mail (2.924)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4, 2008, at 10:19 AM, Dave Jones wrote:

> On Fri, May 30, 2008 at 03:37:01PM -0400, Chuck Lever wrote:
>
>>> Something else of note which I hadn't seen before, usually things  
>>> lock
>>> up just after that first oops. For some reason, today it survived
>>> a little longer, but things really went downhill fast.
>>> It survived a 'dmesg ; scp dmesg davej@gelk', and then wedged solid.
>>> So as well as the oops, it seems we're corrupting memory too.
>>> For reference, this kernel has both SLUB_DEBUG and PAGEALLOC_DEBUG
>>> enabled.
>>
>> I haven't seen this kind of problem here with .26, but yes, it does
>> look like something is clobbering memory during an NFS mount.
>>
>> I introduced some NFS mount parsing changes in this commit range:
>>
>>   2d767432..82d101d5
>>
>> A quick bisect should show which, if any of these, is the guilty
>> party.  If any of these are the problem, I suspect it's 3f8400d1.
>
> I didn't get time to try this out yet (hopefully tomorrow).
> In the meantime, we've just gotten word of another user seeing memory
> corruption with nfs - https://bugzilla.redhat.com/show_bug.cgi?id=449958

449958 could very well be the same problem.  The stack traceback is a  
lot cleaner than the one you originally sent, but there are a lot of  
similarities.  (I doubt this is related to symlinks, as the comment  
suggests).

Is commit 86d61d863 applied to the current rawhide kernel?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
