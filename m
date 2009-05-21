Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZEUJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZEUJwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZEUJwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:52:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58064 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZEUJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:52:16 -0400
Date: Thu, 21 May 2009 10:52:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090521095217.GU8633@ZenIV.linux.org.uk>
References: <Pine.LNX.4.44L0.0905191251170.10557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905191251170.10557-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 12:57:21PM -0400, Alan Stern wrote:
> What's the best way to tell whether the current process has a
> particular struct file among its open files?  Is there any better way
> to find out than blindly calling fget() for each possible fd?
> 
> Is this a totally insane thing to do?

It is insane.  You might lock fdtable and scan it, but as soon as you
drop the spinlock your return value is worthless.

What are you trying to do?  If the process is cooperating, you don't really
need that in the kernel, if it's not, the check is not usable...
