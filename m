Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYCCXwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYCCXwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYCCXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:51:52 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:42932 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYCCXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:51:50 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH 7/9] Audit: internally use the new LSM audit hooks
Date: Mon, 3 Mar 2008 18:51:41 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
References: <20080301194752.GA19636@ubuntu> <20080301200111.GH19636@ubuntu>
In-Reply-To: <20080301200111.GH19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031851.41978.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 3:01:11 pm Ahmed S. Darwish wrote:
> Convert Audit to use the new LSM Audit hooks instead of
> the exported SELinux interface.
>
> Basically, use:
> security_audit_rule_init
> secuirty_audit_rule_free
> security_audit_rule_known
> security_audit_rule_match
>
> instad of (respectively) :
> selinux_audit_rule_init
> selinux_audit_rule_free
> audit_rule_has_selinux
> selinux_audit_rule_match
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
>
>  audit.c       |    7 ------
>  auditfilter.c |   61
> ++++++++++++++++------------------------------------------ auditsc.c 
>    |    9 +++-----
>  3 files changed, 22 insertions(+), 55 deletions(-)

For some reason some of your patches are not coming through with correct 
diffstats (notice the lack of a path relative to the kernel base?).  
Don't worry too much about it as it's not grounds to reject the patch 
(at least in my mind) but it's worth looking into on your end for the 
next time you submit patches.

> Andrew, please atomically merge patch #7 and patch #8. Although
> a system with patch7 and without patch8 will be compiled fine,
> the SELinux Audit hooks are not set up yet. This means below
> audit hooks will point to the dummy hooks instead of SELinux
> ones even if SELinux is enabled.
>
> I could not setup the SELinux hooks first cause they have
> the same name of the old exported SELinux interface with a
> difference of one parameter.

In cases like this where you need patches applied atomically to ensure 
correct operation you can always combine the two patches into one 
(assuming they are still small enough to be posted, which shouldn't be 
a problem here).  Small patches are nice and easy to review, but that 
doesn't mean you have to break everything up if it is awkward.

I've looked over patches #7, #8, and #9 and they look okay to me, but 
I'm not tagging them 'Reviewed-by' because they go beyond areas of the 
kernel that I feel comfortable reviewing at this point.  Rest assured 
there are other on the To/CC line that can help you out (I see James 
Morris already Ack'd your entire patch set).

Thanks for all your work on this, it's a nice improvement.

-- 
paul moore
linux security @ hp
