Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZDNRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZDNRqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZDNRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:46:20 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:34528 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZDNRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:46:19 -0400
Message-ID: <49E4CB39.5080802@cs.columbia.edu>
Date: Tue, 14 Apr 2009 13:43:21 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain> <20090414154139.GA8085@us.ibm.com> <20090414170419.GD27923@x200.localdomain>
In-Reply-To: <20090414170419.GD27923@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Tue, Apr 14, 2009 at 10:41:39AM -0500, Serge E. Hallyn wrote:
>> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>>> On Mon, Apr 13, 2009 at 04:47:01PM -0500, Serge E. Hallyn wrote:
>>>> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>>>>
>>>> Hi Alexey,
>>>>
>>>> as far as I can see, the main differences between this patch and the
>>>> equivalent in Oren's tree are:
>>>>
>>>> 1. kernel auto-selects container init to freeze
>>> Note, auto-select part was dropped, userspace is required to pass pid of
>>> container init exactly. This was done to keep semantic of checkpoint(2)
>>> small and extendable.
>> sys_checkpoint() in this patch still finds the child_reaper of the
>> passed-in pid, doesn't it?  Or are you saying that a later patch in
>> this set removes that?
>>
>>>> 2. kernel freezes tasks
>>>> 3. no objhash taking references
>>> That's because none needed.
>> Right while I have opinions on some things in this list, I didn't
>> mean to imply positions on these items.  My question was:  are
>> there are differences you want to call out?
> 
> Sorry? "none needed" is relevant to only item 3. If tasks don't
> dissapear during checkpoint, why would netns dissapear.
> Taking refcount on checkpoint(2) is likely unneeded.
> 
> But it's low-level detail anyway.

Then you need to prevent anyone from thawing the tasks while you're
checkpointing.

An alternative would be to still grab references, just in case, and
ask to be notified if cgroup was thawed - and abort operation (safely).

Oren.
