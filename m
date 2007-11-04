Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbXKDOGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbXKDOGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 09:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXKDOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 09:06:09 -0500
Received: from 1wt.eu ([62.212.114.60]:3681 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXKDOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 09:06:08 -0500
Date: Sun, 4 Nov 2007 15:05:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: vitalivanov@gmail.com
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071104140552.GA25915@1wt.eu>
References: <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com> <20071014223921.GA4677@1wt.eu> <1192542889.29039.66.camel@dell1.softservecom.com> <20071016154138.GA23326@1wt.eu> <1192559051.29039.139.camel@dell1.softservecom.com> <1192644776.10761.60.camel@dell1.softservecom.com> <35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com> <20071019095313.76990765.zaitcev@redhat.com> <1192815634.7965.53.camel@dell1.softservecom.com> <20071022204539.d3e1d291.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022204539.d3e1d291.zaitcev@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 08:45:39PM -0700, Pete Zaitcev wrote:
> On Fri, 19 Oct 2007 20:40:35 +0300, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> 
> Hi, Vitaly, I added you on cc: for the 2.6 cleanup. Please double-check
> what I'm doing there and use it for your 2.4 version. I hope my intentions
> get clearer with an example. Now, about the specific question:
> 
> > Static lock minor_table_mutex is used for minor table structure.
> > And dev->sem for dev manipulations and that's why for open_count.
> > If you will simply browse /drivers/usb dir for 2.4 you will see that
> > such approach is widely used there.
> > What's not right?
> 
> The fundamental reason why you cannot lock a free-able structure with
> an in-structure lock is this. Imagine thread A locks in order to process
> a disconnect. Thread B wants to open and waits for the lock. Notice that
> the struct is not open, so thread A frees it. At this point, thread B
> is using a freed memory.
> 
> The solution is to lock the instance struct dev with dev->mtx, except
> for the open count, which is locked by a static lock (I'm ignoring
> interrupts here, which cannot use mutexes).
> 
> I'm sorry to say, you're quite right: a number of drivers in 2.4 got
> it wrong, and some (like adutux) carried it through 2.6.23.

Vitaly,

I'm planning on issuing a new 2.4.36 prerelease soon. Have you made any
progress on your code after Pete's recommendations ?

Thanks,
Willy

