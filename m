Return-Path: <linux-kernel-owner+w=401wt.eu-S938734AbXHIGEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938734AbXHIGEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbXHIGE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:04:28 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:55707 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761144AbXHIGE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:04:27 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Add ability to print calltraces tighter on i386
Date: Thu, 9 Aug 2007 08:04:23 +0200
User-Agent: KMail/1.9.7
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
References: <46B9D08F.8080402@openvz.org> <46B9DCAE.4010009@openvz.org> <200708081720.09034.ak@suse.de>
In-Reply-To: <200708081720.09034.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090804.24569.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 8. August 2007, Andi Kleen wrote:
> > Not everyone likes frame buffer
>
> You don't need the frame buffer; cards typically have text mode
> fonts upto 80x50. The node numbers vary, but you can find out yours
> with vga=ask
>
> > but even with it any OOPs in
> > network code which happens in softirq, io scheduler and nearby
> > code that is called after passing through all the VFS hooks
> > and many other examples produce long oopses.
> >
> > Oops-es with only the calltrace of ~50 lines do happen :)
>
> Normally most of it bogus. I had hoped to address this with the dwarf2
> unwinder, which tends to filter them out nicely,
> but Linus unfortunately has developed an quite irrational aversion against
> it and it's not in.
>
> But the problem is with bogus entries in there you have no guarantee
> that the first of your call trace is any useful -- it might be all bogus.
> So i don't really think your option makes much sense.
>
> Another way would be to not dump addresses and use multiple entries
> per line again. I guess that would make more sense as an option.
Maybe a crazy idea, but if some OOPS is reproduceable, it might work to dump 
some subset of the calltrace - every time some other part (randomly).

Eg. If you need to show the last 64 stack words (of 8 characters each), but 
have only space for 80 characters (ie. 8 words in hexadecimal, plus 8 
spaces), you could print some index, and every 8th word from there on ...

Or, to increase the probability of getting information for each try, probably 
use some random steps, too.


Of course, all of this is moot if you've got a serial console ...



Regards,

Phil
