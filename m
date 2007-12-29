Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXL2FJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXL2FJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 00:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXL2FI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 00:08:58 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:46653 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834AbXL2FI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 00:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KnWxagDskfHsJg87z5rI/n0TELusIzanDVzoObcO4yZyxX2s5ZpnFdtkAHlLxO9RuNBhhCZTVJZqT+4sSSGW6tbevqsZoyHRX1vbBztrlT6Nw5WbL6YZoWpYzq5/nbOUtN12uZ/I7Z0UdzTdWWTggrEx4abk0NwjXx31RtMgJUM=
Message-ID: <a8e1da0712282108y74762f1fgf32d401251f3ae5a@mail.gmail.com>
Date: Sat, 29 Dec 2007 13:08:56 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver core
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20071229025506.GL11638@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>
	 <20071229025506.GL11638@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 10:55 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Dec 29, 2007 at 09:10:57AM +0800, Dave Young wrote:
> > @@ -207,9 +207,9 @@ void pci_walk_bus(struct pci_bus *top, v
> >                       next = dev->bus_list.next;
> >
> >               /* Run device routines with the device locked */
> > -             down(&dev->dev.sem);
> > +             mutex_lock(&dev->dev.mutex);
> >               cb(dev, userdata);
> > -             up(&dev->dev.sem);
> > +             mutex_unlock(&dev->dev.mutex);
> >       }
> >       up_read(&pci_bus_sem);
> >  }
>
> Patches should be self-contained for ease of bisecting.  I can't tell
> whether this patch is correct or not because you haven't included all
> the other places that need to change at the same time as this.

Hi,

I will repost them after some fixes.

>
> --
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
