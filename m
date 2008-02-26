Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYBZNgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYBZNgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYBZNgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:36:04 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:56768 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYBZNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:36:01 -0500
Message-ID: <47C415F2.2060905@davidnewall.com>
Date: Wed, 27 Feb 2008 00:06:50 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
References: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org> <200802252313.23399.david-b@pacbell.net> <47C3CD15.1060908@davidnewall.com> <200802260116.18142.david-b@pacbell.net>
In-Reply-To: <200802260116.18142.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Tuesday 26 February 2008, David Newall wrote:
>   
>> Hardware can be inserted and removed while we're in a suspend state; and
>> there's nothing that we can do about it until we resume.  Is it fair to
>> say, then, that having started suspend, we could reasonably ignore any
>> device insertion and removal, and handle it on resume?
>>     
>
> "Ignore" seems a bit strong; those events may be wakeup triggers,
> which would cause the hardware to make it a very short suspend state.
>
> "Defer handling" is more to the point, be it by hardware or software.
>
>   

Of course, "defer".  The insertion has to be handled eventually.  What
I'm wondering is if we can ignore it, and catch it on the resume.


>> Presumably we need to scan for hardware changes on resume.
>>     
>
> Not on most busses I work with; the hardware issues notifications
> whenever the devices are removable.
>   

There's no notification while we're suspended.  Isn't it necessary to
scan all busses on resume, just to know what's on them?
