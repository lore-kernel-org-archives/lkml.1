Return-Path: <linux-kernel-owner+w=401wt.eu-S1751619Ab0ALGQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0ALGQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319Ab0ALGQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:16:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:44326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0ALGQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:16:45 -0500
Message-ID: <4B4C151D.8090903@kernel.org>
Date: Tue, 12 Jan 2010 15:22:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Benjamin LaHaise <bcrl@lhnet.ca>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>	<4B4BC683.7060508@kernel.org> <20100112005308.GL5524@kvack.org> <m1vdf82ksy.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdf82ksy.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Jan 2010 06:16:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/12/2010 10:06 AM, Eric W. Biederman wrote:
>> 64k is too small.  10 gig interfaces can currently service 50-100k users, 
>> each of which requires their own network device.
> 
> 64k is the point at which I stop returning a userful nlink number to
> userspace, sysfs directories can still scale to any size.
> 
> I could legitimately always return nlink == 1, and all userspace
> utilities that I know of would be fine, but I am trying to be a bit
> more polite than that.

I don't think it's more polite.  It's more error-prone.  64k is a
limit where breach would be rare enough to be unexpected but would
still happen on corner cases.  I don't know what would be the end
result of incorrect nlink but it's far better to have something which
behaves consistently than to have something which flips its meaning
after reaching certain rare but still quite possible limit.  If nlink
is something we can ignore, just set it to 1 for all sysfs files.  If
nlink must be kept correct, use 32bit limit and fail to create more.

> I don't see the link count as interesting enough to store more than
> 16bits for it.  Even with 32bits of storage for nlink sysfs would have
> to have to handle the rollover case as I am doing now.  So I don't
> see any advantage to storing more bits.

I really don't think reiserfs's example is a good one to follow
especially with significantly lowered limit.

Thanks.

-- 
tejun
