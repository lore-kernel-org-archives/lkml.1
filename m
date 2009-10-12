Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbZJLR6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbZJLR6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbZJLR6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:58:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbZJLR6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:58:38 -0400
Date: Mon, 12 Oct 2009 10:29:53 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Message-ID: <20091012172953.GA10557@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:03:42PM +0000, Haiyang Zhang wrote:
> >  	ChannelMessageCount
> > -} __attribute__((packed));
> 
> Why the change here?  Isn't this doing the same thing?
> 
> And I'm guessing that not all of these structures are needing to be
> packed, right?  Are they all shared across the HV boundry?
> 
> And is this fixing the problem that Hank and users have reported with
> the current code?  Does this need to get into the 2.6.32 release?
> 
> 
> thanks,
> 
> greg k-h
> ================================================
> Hi Greg,

Odd quoting style :(

> Based on our testing, the #pragma pack(push,1) can pack the data
> correctly for the HyperV to use, but __attribute__((packed)) couldn't
> do this right.

Why?  What does gcc generate differently?  This should be identical.

> These data structures are moved by someone from the original file,
> ChannelMessages.h, which contains structures used for messaging to
> host.

I moved them as they did not need to be in that file, right?

And are all of these structures needing to be packed?

Ideally, we don't deal with packed structures at all, but with offsets
in memory and pick out the proper fields and put them into new
structures if you want to use them that way.  How hard would that be to
do here instead?

> Yes, it's fixing the problem that Hank and users have reported with
> the current code. And yes, 2.6.32 needs this fix.

I still want to figure out what the real difference here is.  Especially
as I removed a lot of the #pragma pack(push,1) lines from the hv code.
If it really is different, all of those patches should be reverted,
right?

thanks,

greg k-h
