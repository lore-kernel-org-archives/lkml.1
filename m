Return-Path: <linux-kernel-owner+w=401wt.eu-S1764630AbYARSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764630AbYARSin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYARSie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:38:34 -0500
Received: from mail.fieldses.org ([66.93.2.214]:57033 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYARSic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:38:32 -0500
Date: Fri, 18 Jan 2008 13:37:57 -0500
To: Peter Staubach <staubach@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] enhanced ESTALE error handling
Message-ID: <20080118183757.GE15158@fieldses.org>
References: <4790C756.2040704@redhat.com> <63F84201-9D38-4588-B237-A15138E94C5A@oracle.com> <4790D9F3.2070503@redhat.com> <451AC300-674E-4DBE-869F-08A9184051B3@oracle.com> <4790E227.506@redhat.com> <D4189D74-D4AB-42CA-A788-40A50518E7DA@oracle.com> <4790EBF3.4060707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790EBF3.4060707@redhat.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 01:12:03PM -0500, Peter Staubach wrote:
> Chuck Lever wrote:
>> On Jan 18, 2008, at 12:30 PM, Peter Staubach wrote:
>>> I can probably imagine a situation where the pathname resolution
>>> would never finish, but I am not sure that it could ever happen
>>> in nature.
>>
>> Unless someone is doing something malicious.  Or if the server is  
>> repeatedly returning ESTALE for some reason.
>>
>
> If the server is repeatedly returning ESTALE, then the pathname
> resolution will fail to make progress and give up, return ENOENT
> to the user level.
>
> A malicious user on the network can cause so many other problems
> than just something like this too.  But, in this case, the user
> would have to predict why and when the client was issuing a
> specific operation and know whether or not to return ESTALE.
> This seems quite far fetched and quite unlikely to me.

Any idea what the consequences would be in this case?  It at least
shouldn't overflow the stack, or freeze the whole machine (because it
spins indefinitely under some crucial lock), or panic, etc.  (If the one
filesystem just becomes unusable--well, fine, what better can you hope
for in the presence of a malicious server or network?)

--b.
