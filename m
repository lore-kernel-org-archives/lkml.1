Return-Path: <linux-kernel-owner+w=401wt.eu-S935105AbZAPPeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105AbZAPPeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZAPPeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:34:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58018 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZAPPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:34:01 -0500
Date: Fri, 16 Jan 2009 16:36:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
Message-ID: <20090116153603.GD2022@elf.ucw.cz>
References: <20090116115512.GA10771@elf.ucw.cz> <4970A696.9070307@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970A696.9070307@steeleye.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 10:24:06, Paul Clements wrote:
> Pavel Machek wrote:
>> The code was written with "oh big kernel lock, please protect me from
>> all the evil" mentality: it does not locks its own data structures, it
>> just hopes that big kernel lock somehow helps.
>>
>> It does not. (My fault).
>>
>> So this uses tx_lock to protect data structures from concurrent use
>> between ioctl and worker threads.
>
> What is the particular problem that this fixes? I thought we had already  
> been careful to take tx_lock where necessary to protect data structures.  
>   Perhaps there is something I missed?

for example lo->sock / lo->file are written to without holding any
lock in current code. (lo->xmit_timeout has similar problem, and other
fields, too).

I used tx_lock to protect those fields.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
