Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbZLQAat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbZLQAat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763111AbZLQAaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:30:46 -0500
Received: from kroah.org ([198.145.64.141]:47233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZLQAao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:30:44 -0500
Date: Wed, 16 Dec 2009 16:30:21 -0800
From: Greg KH <greg@kroah.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
 debug	warning
Message-ID: <20091217003021.GB3512@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org>
 <20091216004739.GB4898@kroah.com>
 <4B28AC09.2000302@redhat.com>
 <20091216134538.GA20857@kroah.com>
 <4B290B95.10306@redhat.com>
 <20091216174632.GA12473@kroah.com>
 <4B29299B.5080704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B29299B.5080704@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:40:27PM +0100, Milan Broz wrote:
> On 12/16/2009 06:46 PM, Greg KH wrote:
> > You will find that all of these are modules, right?  That's being worked
> > on still.
> 
> probably. I see that this implementation is in kernel since import to git...

And you will also note that I didn't paper over the issue by trying to
provide an empty release function :)

> What's the right solution in this particular case?
> It is exactly the same situation (using embedded kobj like module handle does).
> 
> In DM, the whole problem here is that kobject is used for attribute representation
> of mapped device, mapped device struct is using its own reference counting
> and can dissappear before the kobject. So it must properly solve this situation.

Then dynamically create the kobject, as it obviously has a different
lifespan.

Or do something else, but as it is now, you can not have two reference
counts with different lifespan rules, within the same object, and expect
things to work properly.

thanks,

greg k-h
