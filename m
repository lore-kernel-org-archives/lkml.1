Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYCHVsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYCHVsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYCHVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:48:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45609 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYCHVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:48:01 -0500
Date: Sat, 8 Mar 2008 15:47:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080308214757.GA22701@sergelap.austin.ibm.com>
References: <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <20080307173542.GA2552@sergelap.austin.ibm.com> <20080307181431.GA4915@kroah.com> <20080307185052.GA4428@sergelap.austin.ibm.com> <20080308060410.GC13434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308060410.GC13434@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Fri, Mar 07, 2008 at 12:50:52PM -0600, Serge E. Hallyn wrote:
> > Quoting Greg KH (greg@kroah.com):
> > > On Fri, Mar 07, 2008 at 11:35:42AM -0600, Serge E. Hallyn wrote:
> > > > > Do you really want to run other LSMs within a containerd kernel?  Is
> > > > > that a requirement?  It would seem to run counter to the main goal of
> > > > > containers to me.
> > > > 
> > > > Until user namespaces are complete, selinux seems the only good solution
> > > > to offer isolation.
> > > 
> > > Great, use that instead :)
> > 
> > That can't work as is since you can't specify major:minor in policy.
> 
> Your LSM can not, or the LSM interface does not allow this to happen?

No my lsm in fact does, you just can't do it with selinux policy at the
moment.  I was still responding to your "just use selinux" :)

> > So all we could do again is simply refuse all mknod, which we can
> > already do with per-process capability bounding sets.
> 
> I thought we passed that info down to the LSM module, can't you do your
> selection at that point in time?
> 
> And then, just mediate open() like always, right?

Yup, the patch I included inline does that.

An LSM can address the problem.  It just felt like more of a
patch-over-the-real-problem kind of solution.

thanks,
-serge
