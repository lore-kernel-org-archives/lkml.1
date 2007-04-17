Return-Path: <linux-kernel-owner+w=401wt.eu-S1031059AbXDQC4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031059AbXDQC4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031058AbXDQC4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:56:04 -0400
Received: from ozlabs.org ([203.10.76.45]:50700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031059AbXDQC4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:56:02 -0400
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <20070416204410.GA5844@martell.zuzino.mipt.ru>
References: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
	 <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
	 <20070416204410.GA5844@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 12:55:17 +1000
Message-Id: <1176778517.14322.276.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 00:44 +0400, Alexey Dobriyan wrote:
> On Mon, Apr 16, 2007 at 03:38:52PM -0400, Alan Stern wrote:
> >      3. Change the module code so that rmmod can return _before_ the
> > 	module is actually unloaded from memory (but after the module's
> > 	exit routine has completed).  This will lead to more problems.
> > 	For example, what if someone tries to modprobe my_module back
> > 	again before it has finished unloading?
> 
> This problem (or its absence) must be already in tree: module_mutex is
> dropped for the duration of ->exit() function, so init_module(2) could
> load new old module meanwhile.

Only if you give it a different name when loading it the second time.

Rusty.

