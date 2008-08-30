Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYH3Vvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYH3Vvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYH3VvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:51:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1156 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbYH3VvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:51:24 -0400
Date: Sat, 30 Aug 2008 15:18:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: VM: page reclaim does not work on ARM9?
Message-ID: <20080830131821.GC7862@ucw.cz>
References: <462ADBE7F1A69C438B7E2ED56007E6F5ABF9A43F21@exch10.BC-Int.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462ADBE7F1A69C438B7E2ED56007E6F5ABF9A43F21@exch10.BC-Int.NET>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-08-28 09:52:32, Wappler Marcel wrote:
> I do need some help to understand what's going on in the VM of the Linux kernel...
> 
> I wrote a little script which generates a C app with millions of lines of dumb linear running code and a endless loop at the end. I run this app on both PC Linux (swapping enabled) and embedded Linux (Kernel 2.6.24.7, ARM9, swapping disabled).
> 
> The app shall consume a lot of code pages which are used only once (to run the linear code in it) and then stay in the endless loop and never touch all the other pages in memory. Then I consume all of the remaining memory of the system through generating a big file on the tmpfs (whose data resides in memory) with the help of /dev/zero and "dd".
> 
> My expectation was: the VM shall steal (reclaim) all the only once touched pages containing those dumb linear code of the app.
> 
> My observation is: "top" shows that the app is consuming constantly the same huge amount of residential memory during the decreasing free memory space. At some moment the kernel starts a OOM killer on the app instead of reclaiming its unused code pages.
> 
> Keep in mind: the behaviour is the same on both PC Linux (2 GB RAM) and ARM Linux (32MB RAM ) with and without swapping enabled.
> 
> So for me it looks like that any page which is containing code never gets reclaimed from the application it belongs to regardless of its usage.
> 
> Any idias, whats going on?

I guess you should have included example .c code... with some macro
magic it should be easy to create.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
