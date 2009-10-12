Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZJLUZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZJLUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZJLUZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:25:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:59002 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbZJLUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:25:53 -0400
Date: Mon, 12 Oct 2009 13:22:14 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Message-ID: <20091012202214.GA9631@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012172953.GA10557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 08:10:40PM +0000, Hank Janssen wrote:
> 
> >Odd quoting style :(
> 
> We like to keep things lively :)
> 
> >> Based on our testing, the #pragma pack(push,1) can pack the data
> >> correctly for the HyperV to use, but __attribute__((packed)) couldn't
> >> do this right.
> >
> >Why?  What does gcc generate differently?  This should be identical.
> 
> It should, but in practice in this case it does not seem to behave the same
> Way.

Can you figure out why?  What is the output of gcc for both ways?

Can you show what is fixed by this change?

Also note that #pragma packed is not supported by older versions of gcc,
so I don't think that it would work at all on some compiler versions
that are still legal to use for the kernel.  But I'm not quite sure when
it was added, so I might be wrong.

> >Ideally, we don't deal with packed structures at all, but with offsets
> >in memory and pick out the proper fields and put them into new
> >structures if you want to use them that way.  How hard would that be to
> >do here instead?
> 
> It is something that I want to look at in the future. Our primary focus
> Is to get the bug fixed. We cannot do the offset way in the time we
> Have before 2.6.32 closes and still be comfortable we have gone through
> The extensive testing cycle we do on our side.

I can't take this patch until I see what the root problem is here,
sorry.

> >I still want to figure out what the real difference here is.  Especially
> >as I removed a lot of the #pragma pack(push,1) lines from the hv code.
> >If it really is different, all of those patches should be reverted,
> >right?
> 
> Not sure yet if they need to be reverted, after we fixed this bug last week
> We are getting another one, it was masked by the one we just fixed. 
> We are checking into that right now;
> 
> 	BUG: unable to handle kernel NULL pointer dereference at (null)

What is the rest of the oops message?  That's pretty hard to determine
anything from :)

thanks,

greg k-h
