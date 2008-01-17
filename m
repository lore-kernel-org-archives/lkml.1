Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYAQV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYAQV7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYAQV7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:59:10 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:54089 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYAQV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Sb0EQva67aVjkav1/yr6a0iwRxdIMq5wIoJOZmCtQpOI4VuVjdKD0sM7n06pOpG5gjlMKz3oO2KwKBc/4SCcLdbnAF4ZrVGcOxH56AfA514BtQV4C3NLaFQedAQCo/bPlS8VFqKxg6syGvQ+xFOE8+VrDcJAeavwpMMPFMp+0Z8=
Date: Thu, 17 Jan 2008 23:02:36 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117220236.GB2905@ami.dom.local>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117203155.GA2791@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117203155.GA2791@ami.dom.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:31:55PM +0100, Jarek Poplawski wrote:
> On Thu, Jan 17, 2008 at 02:57:36PM -0500, Alan Stern wrote:
...
> > If I recall correctly the nature of the warning was that a method
> > routine for one class (called with the class's mutex held) was creating
> > a second class and locking that class's mutex.  In principle this is
> > perfectly legal and should be allowed for arbitrary depths of nesting,
> > even though it is the sort of thing lockdep is currently unable to
> > handle.

BTW, Dave, if it's only about one such "second class" here, then it
shouldn't be so hard to try this one more level of nesting. I think,
the real problem for lockdep starts when there are more such "second
classes", but it's probably in another place.

You could also have a look at e.g. enum_inode_i_mutex_lock_class in
include/linux/fs.h and fh_lock_nested() in include/linux/nfsd/nfsfh.h,
and maybe define similar enum for this.

Jarek P.
