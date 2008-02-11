Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYBKPew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYBKPew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYBKPe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:34:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43380 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbYBKPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:34:26 -0500
Date: Mon, 11 Feb 2008 07:25:42 -0800
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/8] LinuxPPS core support.
Message-ID: <20080211152542.GD25505@kroah.com>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it> <20080209064531.GA29926@kroah.com> <20080211095346.GA28885@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211095346.GA28885@enneenne.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 10:53:46AM +0100, Rodolfo Giometti wrote:
> On Fri, Feb 08, 2008 at 10:45:31PM -0800, Greg KH wrote:
> > 
> > As you are adding sysfs files, please also describe them in
> > Documentation/ABI/ in this same series of patches.
> 
> Ok. I'm going to add them under "testing".
> 
> > Why not use a default attribute group?
> > 
> > That way the files are created before the uevent is issued, and the
> > amount of code you have to write is much smaller.
> 
> What do you mean exactly? I don't understand what you wish. :'(

If you use a 'struct device' you can use a default attribute group for
that device to be created whenever it is added.

However you are not using the driver core that way, you are just calling
device_create(), which doesn't work that way.

But you can just use an attribute group instead, which still saves you a
lot of code, try using that instead (sysfs_create_group()).

Or go all the way and embed a 'struct device' in your structure, and
create a bus, then you can use the default attribute group, although
that might be a bit more work :)

thanks,

greg k-h
