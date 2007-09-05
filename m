Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbXIEUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbXIEUpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbXIEUpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:45:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:60868 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbXIEUpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:45:23 -0400
Message-ID: <46DF14B2.9050402@qumranet.com>
Date: Wed, 05 Sep 2007 23:42:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, shaohua.li@intel.com,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       general@lists.openfabrics.org
Subject: Re: [PATCH][RFC]: pte notifiers -- support for external page tables
References: <11890103283456-git-send-email-avi@qumranet.com> <20070905204012.GA29272@sgi.com>
In-Reply-To: <20070905204012.GA29272@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend due to broken cc list in my original post]

Jack Steiner wrote:
> On Wed, Sep 05, 2007 at 07:38:48PM +0300, Avi Kivity wrote:
>   
>> Some hardware and software systems maintain page tables outside the normal
>> Linux page tables, which reference userspace memory.  This includes
>> Infiniband, other RDMA-capable devices, and kvm (with a pending patch).
>>
>>     
>
> I like it. 
>
> We have 2 special devices with external TLBs that can
> take advantage of this.
>
> One suggestion - at least for what we need. Can the notifier be
> registered against the mm_struct instead of (or in addition to) the
> vma?
>   

Yes.  It's a lot simpler since this way we don't have to support vma
creation/splitting/merging/destruction.  There's a tiny performance hit
for kvm, but it isn't worth the bother.

Will implement for v2 of this patch.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

