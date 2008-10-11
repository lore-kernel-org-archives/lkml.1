Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbYJKOtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbYJKOtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYJKOsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:48:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49076 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754105AbYJKOsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:48:35 -0400
Date: Sat, 11 Oct 2008 16:35:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Chris Snook <csnook@redhat.com>
Cc: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081011143552.GA1556@ucw.cz>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED1D62.8080100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-08 16:51:46, Chris Snook wrote:
> Stefan Monnier wrote:
>> Google finds some people asking this same question, but I couldn't find
>> any answer to it: what filesystem is recommended to use on an flash
>> based disk that does not give access to the MTD layer (e.g. USB keys,
>> most SSDs, ...)?
>
> Unless you really know what you're doing, you should use a 
> general-purpose disk filesystem.  You probably also want to use the 
> relatime mount option, which is default on some distros.
>
>> Since they do their own wear-levelling, any filesystem should be "safe",
>> but I expect there is still a lot of variance in terms of performance,
>> wear, robustness, ...
>
> Writes to magnetic disks are functionally atomic at the sector level.  
> With SSDs, writing requires an erase followed by rewriting the sectors 
> that aren't changing.  This means that an ill-timed power loss can 
> corrupt an entire erase block, which could be up to 256k on some MLC 
> flash.  Unless you have a RAID card with a battery-backed write cache, 
> your best bet is probably data journaling. On ext3, you can enable this 
> with the data=journal mount option or the rootflags=data=journal kernel 
> parameter for your root filesystem.  It's entirely possible that doing 

I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
if you write data 'nearby' root directory and power fails, bye bye
filesystem, and journal will not help.

Actually ext2 will at least detect damage...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
