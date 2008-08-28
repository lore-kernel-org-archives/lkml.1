Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYH1MLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYH1MLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYH1MLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:11:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYH1MLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:11:47 -0400
Message-ID: <48B69582.4000208@cn.fujitsu.com>
Date: Thu, 28 Aug 2008 20:09:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
References: <48B360CE.2010501@cn.fujitsu.com>	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>	 <48B39319.7070403@cn.fujitsu.com>	 <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>	 <48B4D81D.2040200@cn.fujitsu.com> <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
In-Reply-To: <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Aug 26, 2008 at 9:29 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> And vmalloc can malloc larger memory than kmalloc, is vmalloc() enough?
>> If not, I think using an array of pages is the best choice.
> 
> vmalloc would be simpler, certainly, but it has a higher overhead. And
> since we're dealing with arrays of integers here, it's not too hard to
> manage multiple arrays. Oh, except for sorting them, which would be
> more of a pain. So yes, maybe vmalloc() would be a better choice at
> first.
> 
Yep, these are hard. Which method is your favorite?

My original purpose was to fix a bug as I described. 
This bug and the problem that offering big enough array for a huge
cgroup are orthogonal!

Could you consider/test that is it a bug as I described(and is it as
critical as I described, maybe I was too nervous)?
And this is also a problem: opening a cgroup.tasks twice or will waste
a lot of _physical_ memory.

    Thanks! Lai

