Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbYCEXDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbYCEXDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbYCEW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:58:23 -0500
Received: from namei.org ([69.55.235.186]:49315 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932299AbYCEW6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:58:20 -0500
Date: Thu, 6 Mar 2008 09:56:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, bunk@kernel.org, chrisw@sous-sol.org,
       eparis@parisplace.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH -v5 -mm] LSM: Add security= boot parameter
In-Reply-To: <20080305142948.3d391d84.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0803060951450.26999@us.intercode.com.au>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi>
 <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu>
 <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu>
 <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu>
 <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil> <20080303212433.GA12998@ubuntu>
 <Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au> <20080304030407.GA25686@ubuntu>
 <20080305142948.3d391d84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Andrew Morton wrote:

> > +/* Maximum number of letters for an LSM name string */
> > +#define SECURITY_NAME_MAX	10
> 
> Is this long enough?

I almost flagged this earlier, but I don't think we've ever seen an LSM 
with a longer name, and it can be expanded if needed.  32 or something 
seems similarly arbitrary.

> Please remove this and use compile-time initialisation with DEFINE_SPINLOCK.
> 
> Do we actually need the lock?  This code is only called at boot-time if I
> understand it correctly?

Theoretically, security_module_enable() could be called at any time, 
although it does seem unlikely never to be called at boot, especially if 
multiple LSMs are compiled in.

In that case, perhaps mark the function as __init, and require it be 
called only at boot time.

> Can chosen_lsm[] be __initdata?

With the above, yes.

> > +int security_module_enable(struct security_operations *ops)
> > +}
> 
> I believe this can be __init.

Indeed :-)


- James
-- 
James Morris
<jmorris@namei.org>
