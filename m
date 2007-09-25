Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXIYWxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXIYWxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXIYWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:53:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56194 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXIYWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:53:39 -0400
Date: Tue, 25 Sep 2007 15:53:30 -0700
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070925225330.GA26235@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:27:14AM +0200, Miklos Szeredi wrote:
> I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
> when removing the fuse module.
> 
> This patch titled "kobject: remove the static array for the name"
> looks like it's responsible.  Reverting it cures the problem.
> 
> The root of the problem seems to be, that decl_subsys() initializes
> k_name with a string constant.  Then subsystem_unregister() will put
> the kobject, which will free the k_name.
> 
> So, what's the right way to deal with this?

How is the static kobject created by decl_subsys() getting it's release
function called when it is never really "released" as it is a static
kobject?

The "correct" way to fix this is to dynamically create the subsystem
kobject, and is what I am working toward accomplishing.  But I didn't
think it was necessary just yet.

Let me go dig some more...

thanks,

greg k-h
