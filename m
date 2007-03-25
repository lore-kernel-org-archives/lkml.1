Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXCYTLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXCYTLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXCYTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:11:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46960 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXCYTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:11:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Sun, 25 Mar 2007 21:14:15 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703251428.03382.rjw@sisk.pl> <m1wt1532jb.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt1532jb.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252114.16436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 14:56, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Yes, in kernel/power/disk.c:power_down() .
> >
> > Please comment out the disable_nonboot_cpus() in there and retest (but please
> > test the latest Linus' tree).
> 
> <rant>
> 
> Why do we even need a disable_nonboot_cpus in that path?  machine_shutdown
> on i386 and x86_64 should take care of that.  Further the code that computes
> the boot cpu is bogus (not all architectures require cpu == 0 to be
> the boot cpu), and disabling non boot cpus appears to be a strong
> x86ism, in the first place.

Yes.
 
> If the only reason for disable_nonboot_cpus there is to avoid the
> WARN_ON in init_low_mappings() we should seriously consider killing
> it.

We have considered it, but no one was sure that it was a good idea.

> If we can wait for 2.6.22 the relocatable x86_64 patchset that 
> Andi has queued, has changes that kill the init_low_mapping() hack.

I think we should kill the WARN_ON() right now, perhaps replacing it with
a FIXME comment.

> I'm not very comfortable with calling cpu_down in a common code path
> right now either.  I'm fairly certain we still don't have that
> correct.  So if we confine the mess that is cpu_down to #if
> defined(CPU_HOTPLUG) && defined(CONFIG_EXPERIMENTAL) I don't care.
> If we start using it everywhere I'm very nervous.
> migration when bringing a cpu down is strongly racy, and I don't think
> we actually put cpus to sleep properly either.

I'm interested in all of the details, please.  I seriously consider dropping
cpu_up()/cpu_down() from the suspend code paths.

Greetings,
Rafael
