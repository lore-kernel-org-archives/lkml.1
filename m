Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXKASfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXKASfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXKASfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:35:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbXKASfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:35:24 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH] audit: clear thread flag for new children
Date: Thu, 1 Nov 2007 14:34:46 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
References: <20071026204228.GA1519@suse.de> <200711011033.53265.sgrubb@redhat.com> <20071101172324.GA3938@suse.de>
In-Reply-To: <20071101172324.GA3938@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011434.47147.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 01:23:24 pm Tony Jones wrote:
> > We are looking into this - at one time it did. Someone should follow up
> > with a path correcting this soon. But I doubt the audit system will work
> > correctly if the flag gets removed as there is no good way to add it
> > again later.
>
> So on the syscall path you're now going to something like (pseudocode):
> if (unlikely(current->audit_context)) {audit_syscall_entry()}
> else if (audit_enabled) {audit_alloc(); audit_syscall_entry()}

Something like that. The TIF flag is to pick off processes that we are 
interested in auditing, for performance reasons if audit is disabled the 
context is not created. But if auditing is re-enabled, processes can 
be "repaired" so that the are auditable again by allocating the context on 
the fly the first time we see a process. Without the flag, they never get 
steered into the audit system where this can happen.

> I agree, if this is what you want to do, then clearing the thread flag
> would be a bad idea. 

If any other performance improvements jumps out at you, please bring them up.

> I'd assumed the current behaviour was by design as allocating contexts at
> syscall time doesn't seem a great idea but if you need the functionality,
> you need the functionality. 

Yep

-Steve
