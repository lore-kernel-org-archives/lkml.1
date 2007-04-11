Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXDKWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXDKWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161286AbXDKWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:23:47 -0400
Received: from mx.pathscale.com ([198.186.3.68]:52178 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXDKWXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:23:46 -0400
Message-ID: <461D600E.4070709@pathscale.com>
Date: Wed, 11 Apr 2007 15:24:14 -0700
From: Robert Walsh <rjwalsh@pathscale.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: "Bryan O'Sullivan" <bos@pathscale.com>, openib-general@openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com> <aday7kzooa7.fsf@cisco.com>
In-Reply-To: <aday7kzooa7.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I just queued all of this for 2.6.22.
> 
> Is there any chance of getting a fix for the use-after-free that can
> be caused by allocating something from userspace, failing to mmap the
> buffer and then exiting?  To see what happens, look at how
> ipath_create_cq sticks a struct ipath_mmap_info into the pending mmap
> "list" (and yes it would be much cleaner to just use struct list_head
> here rather than reimplementing a linked list yourself), and then look
> at how ipath_destroy_cq() frees the same structure without checking if
> it has been removed from the pending mmap list.

BTW: any idea how this ever got triggered?  The only way I can see is if 
you're either not using libipathverbs and libibverbs and you just create 
the CQ some other way, which seems unlikely.  Do you know how Jason 
triggered this bug?

I'm also going to fix a problem where hitting the maximum number of CQs 
causes an error return, but doesn't clean up the pending list and thus 
leaks memory.

Regards,
  Robert.
