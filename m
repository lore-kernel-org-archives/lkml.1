Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZFPSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZFPSz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbZFPSzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:55:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759604AbZFPSzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:55:18 -0400
Message-ID: <4A37EA92.7050509@redhat.com>
Date: Tue, 16 Jun 2009 14:55:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 16 Jun 2009, Andrea Arcangeli wrote:
>> On Tue, Jun 16, 2009 at 09:05:27PM +0300, Izik Eidus wrote:
>>> So the question is: is this thing is by desgin? (that kernel thread cant 
>>> call get_user_pages???), should i use something like switch_mm()??
>> I think switch_mm trick should be used for page faults, but gup
>> shouldn't require it because it gets the 'mm' as parameter and the
>> current->mm has to be irrelevant. current->mm is only relevant for
>> gup-fast (obviously :). So I think the only bit that needs fixing is
>> grab_swap_token to not run if current->mm is null.
> 
> Looks like Izik and I hit the same problem (otherwise running well):
> I too decided we needn't do more than avoid the issue in grab_swap_token.
> (I've a feeling someone has hit this issue before with some other thread,
> though I've no idea which - does RHEL include a patch like this perhaps?).

It looks very familiar, indeed.

RHEL 4 and 5 both have code like this in the swap token
code. I seem to remember submitting such code upstream,
too.

I have no idea why it never got upstream, maybe I was
drowned in Xen work at the time, or maybe the bug simply
didn't happen upstream for whatever reason.

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
