Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbXBNJKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbXBNJKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbXBNJKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:10:42 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:20787 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932160AbXBNJKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:10:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GEi4FOMs4SqywqFwNalFCAYfjL8ZCIJn31iQl/iVWAsUcKi4C26uVRrikqVYPyx77mUdKw7MVXSI397WcB1aqQ/lRiB3R2x/j/U2TZGWDThtuWspNq+TcYMId3zZMtnFQudRbgTum2lZ+jtD+OBx96SVoh3UpTPAKl1DmkRL3A8=  ;
X-YMail-OSG: mw10xmwVM1l6PeIIdvXUBfmveM.Cu3uYu6OOXf3WPrrXehvvKfMCXLDS89mxSYyWZ.Jc4_RVliw.aV8Bm67JGPtJg5a7rNxlwrsQeuXg1Bx2kG_AIB2_etzH3FMnaszEpRe5x9YxjY0E8CA-
Message-ID: <45D2D1F6.1020303@yahoo.com.au>
Date: Wed, 14 Feb 2007 20:10:14 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, tony.luck@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com> <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au> <20070213121217.0f4e9f3a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com> <20070213144909.70943de2.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com> <45D266E3.4050905@yahoo.com.au> <Pine.LNX.4.64.0702140727180.4224@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0702140727180.4224@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 14 Feb 2007, Nick Piggin wrote:
> 
>>Can't you have migration without swap?
> 
> 
> Yes: but then the only swap entry it can find (short of page
> table corruption, which isn't really the focus of mincore)
> is a migration entry, isn't it?

Just doesn't seem logical to have CONFIG_SWAP ifdef cover the
whole thing, regardless that it produces the desired result.

I'm going to submit a fixup patch to Linus covering all this
stuff, after making a more comprehensive test case (yes I
actually did test this patch with a few different cases before
submitting it, so I must have been unlucky with uninitialised
data).

If he wants to apply it rather than back out the patch entirely,
its up to him.

I don't think there is any reason to panic. I did completely
forget the result vector, but AFAIKS that's the only real bug
in it.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
