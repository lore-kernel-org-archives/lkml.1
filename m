Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXDJHHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXDJHHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXDJHHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:07:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33254 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXDJHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:07:21 -0400
Message-ID: <461B3795.4020902@garzik.org>
Date: Tue, 10 Apr 2007 03:07:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <Pine.LNX.4.64.0704091944580.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704091944580.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 9 Apr 2007, Andrew Morton wrote:
>>>    10 ?        S<     0:00 [khelper]
>> That one's needed to parent the call_usermodehelper() apps.  I don't think
>> it does anything else.  We used to use keventd for this but that had some
>> problem whcih I forget.
> 
> I think it was one of a long series of deadlocks. 
> 
> Using a "keventd" for many different things sounds clever and nice, but 
> then sucks horribly when one event triggers another event, and they depend 
> on each other. Solution: use independent threads for the events.

Nod.  That's the key problem with keventd.  Independent things must wait 
on each other.

That's why I feel thread creation -- cheap under Linux -- is quite 
appropriate for many of these situations.

	Jeff



