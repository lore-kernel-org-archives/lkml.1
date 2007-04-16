Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbXDPUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbXDPUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXDPUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:43:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:25342 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXDPUnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZTbWJMxn5LQXJRJSPZUZmxYYDgoBNT5TOwyT90/yBYZk8DntxAd3Bx7XnbgvI6ERpm513FXgMPwFfD4GFoKJfcTwA4RT7Nnck0zz+RRCfkSJ41hbONIuI7fO3VenVqKHE0T5k+Mi/kfik0uFBkLYE/Rs6cNgFvhjZ7Pn0JkIEnQ=
Date: Tue, 17 Apr 2007 00:44:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070416204410.GA5844@martell.zuzino.mipt.ru>
References: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com> <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:38:52PM -0400, Alan Stern wrote:
>      3. Change the module code so that rmmod can return _before_ the
> 	module is actually unloaded from memory (but after the module's
> 	exit routine has completed).  This will lead to more problems.
> 	For example, what if someone tries to modprobe my_module back
> 	again before it has finished unloading?

This problem (or its absence) must be already in tree: module_mutex is
dropped for the duration of ->exit() function, so init_module(2) could
load new old module meanwhile.

