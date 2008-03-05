Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbYCEMsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbYCEMsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYCEMr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:47:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:46545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYCEMr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:47:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=v2nQGsYR8RNKT5ElDSIK6NpTtIpXKKf+HEt4uaQBpWrw+z6p5LPLDTY1maJE6E0DQXFGRp0Fq86eWMiMhMLCHvGaVA+bqE+T0cpyAXsZiB3BP6aS+iqUAMHSm7/gb1YdkX6OEz42KW45LcL+JO1cERE/TkZBnVoTzK3gjGvT2z0=
Date: Wed, 5 Mar 2008 14:44:45 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
	loaded
Message-ID: <20080305124445.GA19549@ubuntu>
References: <521493.30745.qm@web36606.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521493.30745.qm@web36606.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 09:45:04AM -0800, Casey Schaufler wrote:
> ----- Original Message ----
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > To: Ahmed S. Darwish <darwish.07@gmail.com>
> > Cc: Casey Schaufler <casey@schaufler-ca.com>; LKML <linux-kernel@vger.kernel.org>
> > Sent: Tuesday, March 4, 2008 9:21:19 AM
> > Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not loaded
> > 
> > 
> > 
> > On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:
> > > 
> > > Smackfs initialization without an enabled Smack leads to
> > > an early Oops that renders the system unusable.
> > 
> > I really think this is bogus. Global enables like this are just wrong, and 
> > a sign that something else bad is going on.
> > 
> > What is the oops? Why does it happen?
...
> 
> One solution would be to tighten the smackfs code so that it
> handles the uninitialized LSM case properly.
> 

IMHO no smackfs code should ever execute if smack isn't loaded.

This means catching it from the very fist step where it registers
itself in init_smk_fs instead of doing several if(we're enabled) cases
in the code path.

The solution should be a _general_ solution, _not_ a SMACK one cause 
SELinux sufferes from exactly the same problem.

a.k.a:

LSMs need a scalable way to know if they're enabled that makes 
everyone happy ( especially Linus ;) ).

Regads to all,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

