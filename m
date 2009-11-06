Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbZKFVpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbZKFVpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZKFVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:45:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45156 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbZKFVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:45:42 -0500
Date: Fri, 6 Nov 2009 13:45:29 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [v11][PATCH 9/9] Document clone_with_pids() syscall
Message-ID: <20091106214529.GB26614@count0.beaverton.ibm.com>
References: <20091105053053.GA11289@us.ibm.com>
 <20091105054204.GI16142@us.ibm.com>
 <20091106183936.GA32531@us.ibm.com>
 <20091106201814.GA26614@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106201814.GA26614@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 12:18:14PM -0800, Matt Helsley wrote:
> On Fri, Nov 06, 2009 at 12:39:36PM -0600, Serge E. Hallyn wrote:
> > Quoting Sukadev Bhattiprolu (sukadev@us.ibm.com):
> > ...
> > > +	If a pid in the @pids list is non-zero, the kernel tries to assign
> > > +	the specified pid in that namespace.  If that pid is already in use
> > > +	by another process, the system call fails (see EBUSY below).
> > > +
> > > +	The order of pids in @pids is oldest in pids[0] to youngest pid
> > > +	namespace in pids[nr_pids-1]. If the number of pids specified in the
> > 
> > In the sys_choosepid() discussion, Matt suggested it would be more
> > user-friendly to have the pid for the youngest pidns be pids[0].
> > That way the user doesn't have to know their pidns depth.
> 
> As far as I could see, Suka's solution also does not require knowing
> the pidns depth (aka level). He made it so that copy_from_user()
> adjusts its destination using the discrepancy between the number of
> pids passed and the number of levels.
> 
> If userspace passes an array with n pids and there are k namespace levels
> then clone_with_pids() makes sure that the kernel sees a pid array like:
> 
> index	  0     ... k - (n + 1)        ...          k - 1
> 	+-----------------------+-------------------------+
> pid_t	| 0 ..................0 | <copied from userspace> |
> 	+-----------------------+-------------------------+

(diagram assumes n != k. If n == k then pids[0] is the pid desired
in the initial namespace..)

> 
> So even though the order is different from choosepid() the calling
> task still doesn't need to know its pidns level. Of course, just
> like choosepid(), n <= k or userspace will get EINVAL.

Forgot to mention that I prefer the way choosepid orders the pids.
It's not inspired by the way that the kernel implements pid namespaces
and has more to do with the way userspace sees things (IMHO). I don't
know if it makes more sense to change clone_with_pids() or have
[e]glibc wrappers swap the array contents.

Cheers,
	-Matt Helsley
