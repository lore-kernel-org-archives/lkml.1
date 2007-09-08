Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbXIHLeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbXIHLeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXIHLeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:34:06 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:54985 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXIHLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:34:05 -0400
Date: Sat, 8 Sep 2007 04:34:03 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@suse.de,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
In-Reply-To: <200709090348.28076.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709080429420.27088@twinlark.arctic.org>
References: <200709071526.51169.jesse.barnes@intel.com>
 <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org>
 <200709090334.27677.nickpiggin@yahoo.com.au> <200709090348.28076.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007, Nick Piggin wrote:

> I've also heard that string operations do not follow the normal ordering, but
> that's just with respect to individual loads/stores in the one operation, I
> hope? And they will still follow ordering rules WRT surrounding loads and
> stores?

see section 7.2.3 of intel volume 3A...

"Code dependent upon sequential store ordering should not use the string 
operations for the entire data structure to be stored. Data and semaphores 
should be separated. Order dependent code should use a discrete semaphore 
uniquely stored to after any string operations to allow correctly ordered 
data to be seen by all processors."

i think we need sfence after things like copy_page, clear_page, and 
possibly copy_user... at least on intel processors with fast strings 
option enabled.

-dean
