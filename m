Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXDPQpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXDPQpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDPQpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:45:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36990 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXDPQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:45:04 -0400
Date: Mon, 16 Apr 2007 17:45:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Message-ID: <20070416164502.GA11762@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200704161811.30364.agruen@suse.de> <20070416162146.GA8029@infradead.org> <200704161840.41343.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161840.41343.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 06:40:41PM +0200, Andreas Gruenbacher wrote:
> On Monday 16 April 2007 18:21, Christoph Hellwig wrote:
> > But anyway, creating fake nameidata structures is not really helpful.
> > If there is a nameidata passed people expect it to be complete, and
> > if you pass them to an LSM people will e.g. try to look into lookup
> > intents.
> 
> I don't actually agree with that: when nfsd creates a file, it still is a file 
> create no matter where it originates from, and so it does make sense to 
> provide the appropriate intent information too. Struct nameidata contains 
> other crap only needed during an actual lookup too --- that's a mess, and the 

You should provide intent information, yes - which your patch didn't :)

And yes, I didn't like doing the ugly intent in nameidata hack, it's
creating loads of problems for various parties, e.g. the stackable
filesystem folks.  Now the basic intent in nameidata mistaken has been
made even worse by passing back a struct file in it conditionally and
doing lots of work in ->lookup that shouldn't be there.  (Which btw,
I expect to cause quite a few problems for apparmor or other lsms,
but I guess so far no one has tried them on NFSv4)

