Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYEODPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYEODPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYEODP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:15:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36304 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYEODP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:15:26 -0400
Date: Wed, 14 May 2008 20:14:58 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
Message-ID: <20080515031458.GA4423@kroah.com>
References: <20080514170316.672f809d@extreme> <20080514181257.74fbb5aa@extreme> <20080514181603.411e834f@extreme> <20080514.182637.211478588.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514.182637.211478588.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 06:26:37PM -0700, David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Wed, 14 May 2008 18:16:03 -0700
> 
> > It is possible that the entry in sysfs already exists, one case of this is
> > when a network device is renamed to bonding_masters. Anyway, in this case
> > the proper error path is for device_rename to return an error code, not to
> > generate bogus backtrace and errors.
> > 
> > Also, to avoid possible races, the create link should be done before the
> > remove link. This makes a device rename atomic operation like other renames.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> I definitely agree with this change.
> 
> We have several cases where device names are user configurable,
> yet the devices live in a directory which also has subdirectories
> created by other subsystems.
> 
> It's pointless to require the top-level guy to look for any
> purge out any subdirectory cases, that's none of it's business.
> 
> I realize the backtrace is useful for finding bugs, but in this
> case it's definitely not appropriate.

Fair enough, I have no objection to these.

David, do you want me to take them through my tree?  Or are they
dependant on the network core changes as well?  If so, I have no
problem you taking them.  Feel free to add a:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
to them in that case.

thanks,

greg k-h
