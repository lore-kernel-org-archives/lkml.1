Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYCHGNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYCHGNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 01:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYCHGMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 01:12:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57493 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYCHGM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 01:12:28 -0500
Date: Fri, 7 Mar 2008 22:04:10 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080308060410.GC13434@kroah.com>
References: <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <20080307173542.GA2552@sergelap.austin.ibm.com> <20080307181431.GA4915@kroah.com> <20080307185052.GA4428@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307185052.GA4428@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 12:50:52PM -0600, Serge E. Hallyn wrote:
> Quoting Greg KH (greg@kroah.com):
> > On Fri, Mar 07, 2008 at 11:35:42AM -0600, Serge E. Hallyn wrote:
> > > > Do you really want to run other LSMs within a containerd kernel?  Is
> > > > that a requirement?  It would seem to run counter to the main goal of
> > > > containers to me.
> > > 
> > > Until user namespaces are complete, selinux seems the only good solution
> > > to offer isolation.
> > 
> > Great, use that instead :)
> 
> That can't work as is since you can't specify major:minor in policy.

Your LSM can not, or the LSM interface does not allow this to happen?

> So all we could do again is simply refuse all mknod, which we can
> already do with per-process capability bounding sets.

I thought we passed that info down to the LSM module, can't you do your
selection at that point in time?

And then, just mediate open() like always, right?

thanks,

greg k-h
