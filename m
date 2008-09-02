Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYIBPV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYIBPV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYIBPVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:21:19 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30764 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbYIBPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:21:18 -0400
Message-ID: <48BD5993.60707@panasas.com>
Date: Tue, 02 Sep 2008 18:19:47 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BC1065.76E4.0078.0@novell.com> <48BBFA67.9070305@panasas.com> <48BC1A10.76E4.0078.0@novell.com> <48BC037F.5010305@panasas.com> <48BC267E.76E4.0078.0@novell.com> <48BC1B31.1050306@panasas.com> <48BD0BB5.76E4.0078.0@novell.com>
In-Reply-To: <48BD0BB5.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2008 15:18:59.0777 (UTC) FILETIME=[3989C310:01C90D0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 18:41 >>>
>> Jan Beulich wrote:
>>>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 17:00 >>>
>>>> What is broken with my BUILD_BUG_ON_ZERO(). I tried all tests and
>>>> it works fine. Do you have a test with unwanted results?
>>>> (Actually it's the original one I have not touched it).
>>> That's the problem - it uses the same sizeof(char[]) approach, and hence
>>> has the same problems that you just try to fix for BUILD_BUG_ON().
>>>
>> No it does not have this problem. Have you tested it? 
>> I have! It works fine. (Complains on non-const expressions)
> 
> For static variables, yes. But not for automatic variables and the like:
> 
> #define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
> 
> int test(int i) {
> 	int x = BUILD_BUG_ON_ZERO(i);
> 
> 	return x;
> }
> 
> You could argue that I could place a simple BUILD_BUG_ON() later in
> the code, but that easily defeats the documentation purposes the
> construct also has (my general position on this is that the check should
> be in or immediately before the statement that depends on the
> enforced restriction).
> 
> Jan
> 

I was able to reproduce your problem now. 

I have made new patchset the final BUILD_BUG_ON_ZERO() I took from you.
But in BUILD_BUG_ON I use a slight variation that satisfies my wishes
and makes BUILD_BUG_ON more like BUG_ON in syntax.

I had to change virtio_has_feature() semantics, though, but I believe it's
not that bad.

Jan maybe you want to put your Signed-off-by: on the last patch?
Please review?

[ I'll post new version of patches that change as reply to the original
 patches ]

Boaz
