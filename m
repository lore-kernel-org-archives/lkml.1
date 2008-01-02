Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYABG6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYABG6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYABG6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:58:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:58262 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYABG6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:58:46 -0500
Date: Tue, 1 Jan 2008 23:00:08 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, greg@kroah.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20080102070008.GA31343@suse.de>
References: <20071229170730.GA1351@kroah.com> <a8e1da0801011654j1427d466m3971f693f0439954@mail.gmail.com> <20080102051828.GA24431@suse.de> <20080101.212501.00751091.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101.212501.00751091.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 09:25:01PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Tue, 1 Jan 2008 21:18:28 -0800
> 
> > But is the usage of this semaphore in the class code really a problem?
> > Has it been seen to cause issues anywhere?  Does it show up on any
> > benchmarks as being something that really needs to be replaced?
> 
> It's a question of maintainability and simplicity also Greg.
> 
> I actually have no idea why you're making any sort of fuss about this.
> To me it's so clear cut that we should do that.

For most cases, yes, I agree with this, but due to the lockdep issues
that occur here, and the whole mess with the suspend path and locking
the device tree, that has been hashed out many times in the past, I am
interested in trying to see if there is any real reason why this is
absolutely necessary to convert.

If no one has noticed any issues in this area, I think the complexity
that will be involved in any such conversion will strongly outweigh any
simplicity that might be expected.

I'm very open to potential patches to do this, just don't ignore the
issues that others have run into in the past when attempting this.

thanks,

greg k-h
