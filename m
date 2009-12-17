Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbZLQXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbZLQXQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbZLQXQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:16:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:32970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558AbZLQXQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:16:29 -0500
Date: Thu, 17 Dec 2009 15:16:21 -0800
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] Driver core: Encourage use of const attributes
Message-ID: <20091217231621.GA5103@suse.de>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:12:10PM +0200, Phil Carmody wrote:
> I know now's probably a bad time to be mentioning const issues
> but I recently a reviewed a patch where 'const' was being removed 
> from a device_attribute structure, and I enquired why. The reason
> was simply so that device_create_file() could be called, it taking
> a non-const attribute pointer. Looking inside, all that function 
> did was pass a pointer to sysfs_create_file, which itself took a
> const pointer. Non-constness was not required at all.
> 
> So here I offer a small patchset which I hope will permit and 
> encourage device and other attributes to be made const, and put 
> in read-only sections.
> 
> 1-3 address the three attribute types which seemed to be trivially 
> const-able, and are the important part of the set.

I like these, very nice.

> 4 adds a new macro to encourage the use of Const ATTRibutes,
> and may need a better name. (I wanted to avoid RO, for example.)

Hm, is this really needed?  How badly do things break if you change the
current attribute macros to use 'const'?  What subsystems are not using
const?

> 5 and 6 are merely two quick examples of how easy it is to adopt 
> the new const convention. In reality, these structures have been
> constant and treated as constant by the driver core all along, it's
> just that one word was missing from a few important places.
> 
> I would hope to submit a patchset with 1-3 and a possibly modified 
> 4. The migrations themselves will belong in different trees.

I'll be glad to take 1-3 now, and queue it up for .34.

thanks,

greg k-h
