Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZDBLZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZDBLZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZDBLZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:25:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36837 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803AbZDBLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:25:31 -0400
Date: Thu, 2 Apr 2009 16:29:07 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: david@lang.hm
Cc: Bron Gondwana <brong@fastmail.fm>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090402052907.GB6832@brong.net>
References: <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm> <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm> <49D3DDBF.9060406@ursus.ath.cx> <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm> <20090402023040.GA20071@brong.net> <alpine.DEB.1.10.0904012145450.30587@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904012145450.30587@asgard.lang.hm>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 09:55:18PM -0700, david@lang.hm wrote:
> On Thu, 2 Apr 2009, Bron Gondwana wrote:
>
>> On Wed, Apr 01, 2009 at 03:29:29PM -0700, david@lang.hm wrote:
>>> the problem with this approach is that the dcache has no provision for
>>> there being two (or more) copies of the disk block in it's cache, adding
>>> this would significantly complicate things (it was mentioned briefly a
>>> few days ago in this thread)
>>
>> It seems that it's obviously the "right way" to solve the problem
>> though.  How much does the dcache need to know about this "in flight"
>> block (ok, blocks - I can imagine a pathological case where there
>> were a stack of them all slightly different in the queue)?
>
> but if only one filesystem needs this caability is it really worth  
> complicating the dcache for the entire system?

Depends if that one filesystem is expected to have 90% of the
installed base or not, I guess.  If not, then it's not worth
it.  If having something like this makes that one filesystem
the best for the majority of workloads, then hell yes.

>> You'd be basically reinventing MVCC-like database logic with
>> transactional commits at that point - so each fs "barrier" call
>> would COW all the affected pages and write them down to disk.
>
> one aspect of mvcc systems is that they eat up space and require 'garbage 
> collection' type functions. that could cause deadlocks if you aren't  
> careful.

I guess the nice thing here is that the only consumer for the older
versions is the disk flushing thread, so figuring out when to cleanup
wouldn't be so hard as in a concurrent-users database.

But I'm speculating with no little hands-on experience with the
code.  I just know I'd like the result...

Bron ( creating consistent pages on disk that never really
       existed in memory sounds... exciting )
