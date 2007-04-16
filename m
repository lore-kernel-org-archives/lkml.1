Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDPSIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDPSIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXDPSIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:08:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57451 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXDPSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:08:30 -0400
Date: Mon, 16 Apr 2007 11:05:59 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
Message-ID: <20070416180559.GA5662@kroah.com>
References: <20070416193627.1db62136@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416193627.1db62136@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 07:36:27PM +0200, Cornelia Huck wrote:
> Grab and release the module kobject refcount if kobj->owner is set.
> This prevents calls to the release function after the module has
> been unloaded.

But doesn't this cause reference counts to be grabbed on modules that
don't want them?  (like network drivers)?

I don't understand what exactly you are trying to protect from here.
Especially as Tejun just ripped the lifetime rules between sysfs and
kobjects apart.

thanks,

greg k-h
