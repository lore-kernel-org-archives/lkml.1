Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbXK3BV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbXK3BV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933223AbXK3BVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:21:19 -0500
Received: from hierophant.serpentine.com ([64.81.58.173]:59484 "EHLO
	hierophant.serpentine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbXK3BVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:21:18 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 20:21:18 EST
Message-ID: <474F63A5.2000907@serpentine.com>
Date: Thu, 29 Nov 2007 17:13:09 -0800
From: "Bryan O'Sullivan" <bos@serpentine.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net>
In-Reply-To: <474CF06C.8020208@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> would the following code be SMP safe?
> 
> hold_lock = mutex_trylock()

The common way to deal with this is first to restructure your function 
into two.  One always acquires the lock, and the other (often written 
with a "__" prefix) never acquires it.  The never-acquire code does the 
actual work, and the always-acquire function calls it.

You then refactor the callers so that you don't have any code paths on 
which you can't predict whether or not the lock will be held.

	<b
