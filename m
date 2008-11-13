Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYKMNYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYKMNYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKMNYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:24:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYKMNYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:24:07 -0500
Message-ID: <491C2A63.1030804@kernel.org>
Date: Thu, 13 Nov 2008 22:23:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 13:23:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Miklos Szeredi wrote:
>> Hmm... yeah, allocating handle from kernel should work fine, but I
>> wouldn't worry about race here.  We can just use 64 bit and guarantee
>> that any handle won't be reused ever.
> 
> Btw, the protocol could be simplified even more by getting rid of all
> acknowledgements:
> 
> <- POLL-request(pollhandle) (alloc handle)
> ...
> -> POLL-notification(pollhandle)
> ...
> <- POLL_RELEASE(pollhandle)
> 
> So normally ->poll() wouldn't have to sleep at all.  If the POLL
> request fails for some reason, userspace just sends a notification
> with the respective error.

We don't need POLL_RELEASE but we still need POLL-reply (to request) to
send revents.  We can put that into notification too.  Hmmm... Yeah,
that could be simpler for FUSE servers.  I'll venture that way.

Thanks.

-- 
tejun
