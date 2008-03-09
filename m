Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbYCIDPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbYCIDPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 22:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYCIDPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 22:15:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37785 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYCIDPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 22:15:12 -0500
Date: Sat, 8 Mar 2008 19:15:18 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080309031518.GA24955@kroah.com>
References: <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <20080307173542.GA2552@sergelap.austin.ibm.com> <20080307181431.GA4915@kroah.com> <20080307185052.GA4428@sergelap.austin.ibm.com> <20080308060410.GC13434@kroah.com> <20080308214757.GA22701@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308214757.GA22701@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 03:47:57PM -0600, Serge E. Hallyn wrote:
> Quoting Greg KH (greg@kroah.com):
> > On Fri, Mar 07, 2008 at 12:50:52PM -0600, Serge E. Hallyn wrote:
> > > Quoting Greg KH (greg@kroah.com):
> > > > On Fri, Mar 07, 2008 at 11:35:42AM -0600, Serge E. Hallyn wrote:
> > > > > > Do you really want to run other LSMs within a containerd kernel?  Is
> > > > > > that a requirement?  It would seem to run counter to the main goal of
> > > > > > containers to me.
> > > > > 
> > > > > Until user namespaces are complete, selinux seems the only good solution
> > > > > to offer isolation.
> > > > 
> > > > Great, use that instead :)
> > > 
> > > That can't work as is since you can't specify major:minor in policy.
> > 
> > Your LSM can not, or the LSM interface does not allow this to happen?
> 
> No my lsm in fact does, you just can't do it with selinux policy at the
> moment.  I was still responding to your "just use selinux" :)

I never said "use selinux", do you think I am crazy?  :)

Just use your own lsm, that's all I recommended.

> > > So all we could do again is simply refuse all mknod, which we can
> > > already do with per-process capability bounding sets.
> > 
> > I thought we passed that info down to the LSM module, can't you do your
> > selection at that point in time?
> > 
> > And then, just mediate open() like always, right?
> 
> Yup, the patch I included inline does that.

Great.  But don't put that other file in the core kernel, put it in
security/ please.

> An LSM can address the problem.  It just felt like more of a
> patch-over-the-real-problem kind of solution.

I disagree, it sounds exactly like what LSM is for.

thanks,

greg k-h
