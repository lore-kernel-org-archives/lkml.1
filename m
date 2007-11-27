Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXK0Fe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXK0Fe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbXK0Feg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:34:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbXK0Fef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:34:35 -0500
Date: Mon, 26 Nov 2007 21:33:21 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <teheo@suse.de>
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly by
	sysfs.c:subsys_attr_store()
Message-ID: <20071127053321.GA975@kroah.com>
References: <1195683419.16019.225.camel@grinch> <20071126203116.0c93cdb9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126203116.0c93cdb9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 08:31:16PM -0800, Andrew Morton wrote:
> On Wed, 21 Nov 2007 15:16:59 -0700 Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > The buf in fs/sysfs.c:subsys_attr_store() does not seem to be updated
> > correctly when returning a negative value (indicating that an error
> > condition has occurred) is returned.  If a negative value is returned,
> > the next subsequent call to subsys_attr_store will have the contents of
> > buf appended to the previous call.
> 
> subsys_attr_store() gets deleted by
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kset-kill-subsys-attr.patch
> 
> So maybe we will soon accidentally fix whatever-this-is?  Or maybe we will
> faithfully maintain it.

Yes, subsys attributes go away, but this is showing a bug in the sysfs
core with attributes, not in the "middle" layers of attributes.

I bounced the original bug report to Tejun, who has been changing the
logic around this area to see if he sees anything that might be
different now.

Tejun?

thanks,

greg k-h
