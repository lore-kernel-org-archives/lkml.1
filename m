Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbYCDEKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbYCDEKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYCDEJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:09:53 -0500
Received: from namei.org ([69.55.235.186]:52626 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754162AbYCDEJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:09:52 -0500
Date: Tue, 4 Mar 2008 15:07:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Eric Paris <eparis@parisplace.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v5 -mm] LSM: Add security= boot parameter
In-Reply-To: <20080304030407.GA25686@ubuntu>
Message-ID: <Xine.LNX.4.64.0803041503350.8815@us.intercode.com.au>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi>
 <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu>
 <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu>
 <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu>
 <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil> <20080303212433.GA12998@ubuntu>
 <Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au> <20080304030407.GA25686@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:

> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: James Morris <jmorris@namei.org>

> +	int rc = 1;
> +
> +	spin_lock(&chosen_lsm_lock);
> +	if (!*chosen_lsm)
> +		strncpy(chosen_lsm, ops->name, SECURITY_NAME_MAX);
> +	else if (strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
> +		rc = 0;
> +	spin_unlock(&chosen_lsm_lock);
> +
> +	if (rc)
> +		printk(KERN_INFO "Security: Loading '%s' security module.\n",
> +		       ops->name);
> +
> +	return rc;

Possibly consider using 0 for success and -EBUSY on failure (but not a 
showstopper for me, as it's not really an "error").


- James
-- 
James Morris
<jmorris@namei.org>
