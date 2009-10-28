Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZJ1P4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZJ1P4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZJ1P4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:56:13 -0400
Received: from kroah.org ([198.145.64.141]:35764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZJ1P4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:56:12 -0400
Date: Wed, 28 Oct 2009 08:51:16 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091028155116.GA1434@kroah.com>
References: <20091022091333.GA31023@elf.ucw.cz>
 <20091026234332.GB26583@kroah.com>
 <20091027001702.GA5019@elf.ucw.cz>
 <20091027030039.GA6195@kroah.com>
 <20091027081921.GG5019@elf.ucw.cz>
 <20091027165750.GA24477@kroah.com>
 <20091027193330.GB19379@elf.ucw.cz>
 <20091027204445.GA28878@kroah.com>
 <20091027232521.GA16782@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027232521.GA16782@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 12:25:22AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > What is so wrong with wakelocks? They are just nops in this case.
> > 
> > Are they really?  Then why is the whole large file needed?
> 
> It is probably not, I went to "submit vendor code, then clean it up"
> mode. CONFIG_HAS_WAKELOCK should be disabled, so it basically stubs
> itself out.
> 
> > > 2) you submit it
> > 
> > Wait, it has to BUILD!  This code has never been able to be built.  Only
> > after I disabled it from the CONFIG_ANDROID have I noticed this, which
> > is my fault.  But it needs to get fixed, and taking a bunch of code in
> > addition to the mess we have now, seems like the wrong way to do it.
> 
> It seems to be the only reasonable way. gpio is used from all the
> other stuff, and removing it is not really an option.
> 
> > > Now, I see that wakelocks are show-stopper for merging into kernel
> > > proper, but what is the problem for staging? We merged drivers with
> > > OS_MEMORY_ALLOCATE(); wakelocks are just nops in this case.
> > > 
> > > Could we please clean this driver in-tree? (Wakelocks are already nops
> > > due to #ifdef magic, cleaning them incrementally is easy.)
> > 
> > With this patch, will it build properly?
> 
> Its certainly way closer to building... it builds for me, with
> something like below; platform devices really are initialized from
> board-* files and get passed parameters.

Ick.  This isn't ok, we can't take patches for staging stuff in files
outside of drivers/staging/

So for now, I've deleted the drivers/staging/dream/ directory from my
tree, which will get pushed for 2.6.33.  Please clean the code up and
get it into buildable shape and I will be glad to add the drivers back
into the staging directory at that time.

thanks,

greg k-h
