Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXL2CzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXL2CzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXL2CzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:55:11 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41285 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXL2CzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:55:10 -0500
Date: Fri, 28 Dec 2007 19:55:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver core
Message-ID: <20071229025506.GL11638@parisc-linux.org>
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 09:10:57AM +0800, Dave Young wrote:
> @@ -207,9 +207,9 @@ void pci_walk_bus(struct pci_bus *top, v
>  			next = dev->bus_list.next;
>  
>  		/* Run device routines with the device locked */
> -		down(&dev->dev.sem);
> +		mutex_lock(&dev->dev.mutex);
>  		cb(dev, userdata);
> -		up(&dev->dev.sem);
> +		mutex_unlock(&dev->dev.mutex);
>  	}
>  	up_read(&pci_bus_sem);
>  }

Patches should be self-contained for ease of bisecting.  I can't tell
whether this patch is correct or not because you haven't included all
the other places that need to change at the same time as this.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
