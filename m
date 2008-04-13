Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYDMBAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYDMBAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 21:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYDMBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 21:00:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58490 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYDMBAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 21:00:02 -0400
Date: Sat, 12 Apr 2008 19:59:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       matthltc@us.ibm.com, hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Helper patches for PTY namespaces
Message-ID: <20080413005936.GA21021@sergelap.austin.ibm.com>
References: <20080412172933.GA19295@us.ibm.com> <1208027215.28187.17.camel@x61.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208027215.28187.17.camel@x61.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> On Sat, 2008-04-12 at 10:29 -0700, sukadev@us.ibm.com wrote:
> > Some simple helper patches to enable implementation of multiple PTY
> > (or device) namespaces.
> > 
> > 	[PATCH 1/4]: Propagate error code from devpts_pty_new
> > 	[PATCH 2/4]: Factor out PTY index allocation
> > 	[PATCH 3/4]: Move devpts globals into init_pts_ns
> > 	[PATCH 3/4]: Enable multiple mounts of /dev/pts
> > 
> > This patchset is based on earlier versions developed by Serge Hallyn
> > and Matt Helsley.
> 
> Suka Stop.
> 
> The first two patches appear to just be cleanups and as such should be
> able to stand on their own.  Mentioning that you found these
> opportunities while working on your pts namespace is fine.  Justifying
> the cleanups this way is not.
> 
> When you mentioned you intended to just resend the cleanups this is not
> at all what I thought you were about.  So please just get the first two
> patches in a form that stands by themselves.

It took me a minute to figure out what you were offended by, but I see,
the patches still introduce a "pts ns", which shouldn't exist at all.

> The pts namespace as designed is not acceptable.
> 
> The problem you are trying to solve with the pts namespace is real.
> 
> So what we need is a device namespace and possibly and incremental path
> to get there.  A device namespace would abstract the device number to
> device mapping for all devices.  A safe incremental path would disable
> all device number to device mappings for process in that namespace.  So
> all functionality would be gone, then it would enable certain mappings
> and certain pieces of the functionality if the code in the kernel is not
> clean enough that we can do it all in one go.
> 
> We need to see that path.  Only then can we take patches that add
> namespace specific goo.  The pattern I am proposing has worked quite
> well for the network namespace.  Meanwhile the uid namespace which
> follows the pattern you seem to be following now seems does not look to
> be completed any time soon.

(you know perfectly well that we're holding off on any further real
uidns work until netns is complete and you have time to partake in the
design - it wouldn't be any fun without you :)

> So send your clean up patches and then let's architect this thing so we
> are really talking about a namespace.  Then we can update devpts to
> capture the device namespace on mount and do it's work in a namespace
> specific manner.

Sounds reasonable to me.

thanks,
-serge
