Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXDLUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXDLUb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXDLUb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:31:59 -0400
Received: from 1wt.eu ([62.212.114.60]:1766 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXDLUb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:31:58 -0400
Date: Thu, 12 Apr 2007 22:31:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pedro <linux_user@izecksohn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070412203153.GJ943@1wt.eu>
References: <200704110223.31291.linux_user@izecksohn.com> <200704120219.03171.linux_user@izecksohn.com> <20070412112545.GA28148@thunk.org> <200704121135.32160.linux_user@izecksohn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704121135.32160.linux_user@izecksohn.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 11:35:32AM -0300, Pedro wrote:
> On Thursday 12 April 2007 08:25, Theodore Tso wrote:
> > likely going to be in deep trouble anyway.  Even if you disable the
> > OOM killer, now random malloc()'s will start returning NULL because
> > your system doesn't have enough memory.  Do you have intelligent error
> > handling and recovery mechanisms for every single malloc() failure?
> 
>   When malloc return NULL, the process may tell the user ENOMEM.
>   When OOM kill the process, the user claim the program sometimes die.

Then use overcommit=2. The default overcommit mode is a convenience provided
to allow poorly designed applications run even when they pretend they need
gigs of RAM when they only use a few tens of megs.

If your application correctly handles malloc(), simply switch overcommit
to 2 and let the system refuse to allocate memory when none is available,
then your application will be aware of this by the NULL result to malloc()
calls. It is a normal behaviour.

I do have appliances which run perfectly controlled software with
overcommit_mode=2 and overcommit_ratio around 70% and without any
swap, and they work like a charm. It just requires some finer grained
tuning on your side. I don't see what the problem is here. You know
the app, you know how much RAM you want to allocate to it, you know
how much you want to keep free. Then say this to the system.

BTW, ulimit -v is your friend here too, and does not require to be root.

Regards,
Willy

