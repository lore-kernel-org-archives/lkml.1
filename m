Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbXLLG2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbXLLG2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXLLG16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:27:58 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56031 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXLLG15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:27:57 -0500
Date: Wed, 12 Dec 2007 11:18:59 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Add Documentation for FAIR_USER_SCHED sysfs files
Message-ID: <20071212054859.GC1486@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071212023836.GB1486@linux.vnet.ibm.com> <20071212053556.GA25334@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212053556.GA25334@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 09:35:56PM -0800, Greg KH wrote:
> On Wed, Dec 12, 2007 at 08:08:36AM +0530, Dhaval Giani wrote:
> > 
> > This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
> > to Documentation/ABI.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-uids |   10 ++++++++++
> >  1 files changed, 10 insertions(+)
> > 
> > Index: current/Documentation/ABI/testing/sysfs-kernel-uids
> > ===================================================================
> > --- /dev/null
> > +++ current/Documentation/ABI/testing/sysfs-kernel-uids
> > @@ -0,0 +1,10 @@
> > +What:		/sys/kernel/uids/<uid>/cpu_shares
> > +Date:		December 2007
> > +Contact:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > +		Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > +Description:
> > +		The /sys/kernel/uids/<uid>/cpu_shares tunable is used
> > +		to set the cpu bandwidth a user is allowed. This is a
> > +		propotional value. What that means is that if there
> > +		are two users logged in, each with shares 1024, they
> > +		will get equal CPU bandwidth.
> 
> Hm, how about describing the units here?  Can you put "10" in each file
> and everyone will get the same share?  100?  1?  1024 seems like an odd
> "share" number.  Unless there is some other document you wish to refer
> people to do help describe these values?
> 

It is proportional. That is, if two users have same value for shares,
they will get equal bandwidth on the CPU. If they are in the ratio 1:2,
then they will share it in that ratio. I've updated the patch for this.
Hope it is clearer.

Thanks,
--

This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
to Documentation/ABI.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 Documentation/ABI/testing/sysfs-kernel-uids |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

Index: current/Documentation/ABI/testing/sysfs-kernel-uids
===================================================================
--- /dev/null
+++ current/Documentation/ABI/testing/sysfs-kernel-uids
@@ -0,0 +1,14 @@
+What:		/sys/kernel/uids/<uid>/cpu_shares
+Date:		December 2007
+Contact:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+		Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+Description:
+		The /sys/kernel/uids/<uid>/cpu_shares tunable is used
+		to set the cpu bandwidth a user is allowed. This is a
+		propotional value. What that means is that if there
+		are two users logged in, each with an equal number of
+		shares, then they will get equal CPU bandwidth. Another
+		example would be, if User A has shares = 1024 and user
+		B has shares = 2048, User B will get twice the CPU
+		bandwidth user A will. For more details refer
+		Documentation/sched-design-CFS.txt

-- 
regards,
Dhaval
