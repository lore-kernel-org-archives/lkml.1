Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbYCBH7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbYCBH7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 02:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYCBH64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 02:58:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:65038 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYCBH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 02:58:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=kdDHbwW34KKZqGI/YYvgiu0eX/YSFpU5/T0a3Wna2yoTFtg8QV/F/VNg4rb8DTbFvvhQ7DSpJUzlox2W/X1Uf0yqVj8L3+TLnNybF7xXmuGg4jYehrMjO4/mvURyZWU+a/XQ3wsXO4LtQCvFYzJhzi829sAq/XxUMaBNDqyGZVw=
Date: Sun, 2 Mar 2008 09:55:49 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2 -mm] LSM: Add security= boot parameter
Message-ID: <20080302075549.GB3215@ubuntu>
References: <20080301232708.GA625@ubuntu> <230454.43756.qm@web36609.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230454.43756.qm@web36609.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 07:41:04PM -0800, Casey Schaufler wrote:
> 
> --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> >
...
> > 
> >  
> >  static struct security_operations selinux_ops = {
> > +	.name =				"selinux",
> > +
> >  	.ptrace =			selinux_ptrace,
> >  	.capget =			selinux_capget,
> >  	.capset_check =			selinux_capset_check,
> > @@ -5420,7 +5422,8 @@ static __init int selinux_init(void)
> >  {
> >  	struct task_security_struct *tsec;
> >  
> > -	if (!selinux_enabled) {
> > +	if (!selinux_enabled || !security_module_enable(&selinux_ops)) {
> > +		selinux_enabled = 0;
> >  		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
> 
> How about "SELinux: Not enabled because LSM %s is already enabled.\n"
> 

Looks better. I'll resend the patch once I know the answer of the SMP
point I asked about in the same thread.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

