Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXFLRxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXFLRxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXFLRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:53:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbXFLRxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:53:22 -0400
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
From: Karl MacMillan <kmacmill@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andreas Gruenbacher <agruen@suse.de>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070612153431.GB14397@sergelap.austin.ibm.com>
References: <20070514110607.549397248@suse.de>
	 <200706110110.35553.agruen@suse.de>
	 <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil>
	 <200706111755.33162.agruen@suse.de>
	 <20070611190222.GB18276@sergelap.austin.ibm.com>
	 <1181653234.17547.89.camel@moss-spartans.epoch.ncsc.mil>
	 <20070612153431.GB14397@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 12 Jun 2007 01:17:17 -0400
Message-Id: <1181625438.18618.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.3 (2.11.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 10:34 -0500, Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@tycho.nsa.gov):

[...]

> > 
> > If we added support for named type transitions to SELinux, as proposed
> > earlier by Kyle Moffett during this discussion, wouldn't that address
> > that issue without needing a DTE-like approach?  The concept is to add
> 
> Haven't read his message, but based on what you laid out here sure, that
> sounds good.  It still, like my dte approach, might have some trouble
> with the wildcard/regex rules AA allows.  And while it might perfectly
> reproduce my original DTE behavior, I don't think it does what AA wants
> on bind mounts.  (Whether what AA wants for bind mounts makes sense I'm
> still not convinced, especially with user mounts coming soon (or already
> here?), but I'm staying out of that discussion for now)
> 
> > the last component name as a further input to the labeling decision for
> > new files, in addition to the existing use of the creating process'
> > label, the parent directory label, and the kind of file.  Then, you
> > could have something like:
> > type_transition <domain> var_log_hosts_t:file "messages" messages_t;
> > 
> > The last component name is already available, so that doesn't require
> > any changes to LSM, and it would be a straightforward extension of
> > SELinux to support the above - it doesn't change the model at all, just
> > adds a further input to the new file labeling logic.
> 
> And eliminates the need for restorecond?
> 

Unlikely in the short term - restorecond is also used to reset contexts
on critical files in /etc that might loose the context because tools
used to update them are not correctly preserving contexts
(e.g., /etc/mtab, etc/resolv.conf).

Actually - this whole notion restorecond as a critical component of
SELinux because of a "new file problem" is pretty overblown. The default
config file ships with:

/etc/resolv.conf
/etc/samba/secrets.tdb
/etc/mtab
/var/run/utmp
/var/log/wtmp
~/public_html
~/.mozilla/plugins/libflashplayer.so

So the only things that would be helped by type_transition rules with a 
name component would be public_html and libflashplayer.so.

Karl

