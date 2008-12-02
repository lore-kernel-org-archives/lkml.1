Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYLBV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYLBV6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLBV6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:58:03 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52582 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbYLBV6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:58:02 -0500
Date: Tue, 2 Dec 2008 16:57:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: roel kluin <roel.kluin@gmail.com>, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious
	unsigned wrap
Message-ID: <20081202215758.GE20858@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bill Davidsen <davidsen@tmr.com>, roel kluin <roel.kluin@gmail.com>,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <49343AD9.4020606@gmail.com> <20081202132441.GC16172@mit.edu> <49356B96.7070900@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49356B96.7070900@tmr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:08:38PM -0500, Bill Davidsen wrote:
> Sorry, you are reading it wrong, the i values inside the loop are  
> identical to those in the original. The value of i starts at count, and  
> the test comes *before* the value is used inside the loop. The values of  
> i inside the loop start at count-1 and go to zero, just as it did in the  
> original. That's why the "i--" is there, the test is on the  
> unincremented value range count to one, but the value inside the loop is  
> correct (or at least is the same as the original patch).

You're right; my bad.  But with something like this:

>>> +	for (i = count; i--; ) {

...where there is no third part of the for loop, and a decrement in
the second part of the loop, just for clarity's sake, it's much better
to write it as a while loop.

						- Ted
