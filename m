Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZI1Hxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZI1Hxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZI1Hxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:53:53 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:32910
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbZI1Hxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:53:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAAIwErLO0En/2dsb2JhbADTTYQeBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,465,1249228800"; 
   d="scan'208";a="584593772"
Message-ID: <4AC06B84.9010004@themaw.net>
Date: Mon, 28 Sep 2009 15:53:40 +0800
From: Ian Kent <raven@themaw.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@sun.com>,
       Yehuda Saheh <yehuda@newdream.net>, Jim Garlick <garlick@llnl.gov>
Subject: Re: [RFC PATCH 00/11] autofs4 - update autofs4 to deal with VFS locking
 change
References: <20090924082036.22151.85151.stgit@zeus.themaw.net> <Pine.LNX.4.64.0909240835390.25940@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.0909240835390.25940@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> On Thu, 24 Sep 2009, Ian Kent wrote:
> 
>> A change to the VFS path walk locking is needed to resolve an issue
>> identified by Sage Weil. This locking change requires significant
>> changes to the autofs4 module to allow it to callback to userspace
>> without introducing a deadlock.
>>
>> To cope with the change the autofs4 module needs to redirect mount
>> requests from ->d_revalidate() to ->lookup() if the directory
>> inode mutex is held when a callback needs to be done. Note that we
>> cannot redirect these requests when the mutex is not held because,
>> to function correctly, the mutex must be held over both revalidate
>> and lookup.
>>
>> Of the patches in the series most are cleanups and refactoring done
>> to keep the real change in "autofs4 - always use lookup for lookup"
>> as clean as possible. Unfortuneately, there is still quite a bit
>> left in it.
>>
>> Also, I need confirmation that the patch that changes the VFS path
>> walk locking is in fact correct, or at least like for like to what
>> will be submitted. I had some difficulty with the original patches
>> that were paosted. The patch in question below is "vfs: make
>> real_lookup do dentry revalidation with i_mutex held".
> 
> It looks identical to be the original two folded into one patch.  I'll 
> repost those two now, freshened against Linus' tree.  The first has just 
> the functional change, and the cleanup is in the second (as per 
> Christoph's review).

Yes, after checking, the patch I was using is functionally the same as
the combination of the two you re-posted. So all is good for may part.

Ian

