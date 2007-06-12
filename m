Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbXFLTBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbXFLTBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXFLTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:00:52 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:23653 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750768AbXFLTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:00:51 -0400
X-YMail-OSG: PGTDEjwVM1nSAnxWP0LItqiXG.16oHFCBvF1eec64mytLszttwx96T7kYZmMoagIxcccpNkKjppHhL7kEc1lBGUwVz20nlp3C8A5TXtv.2LBl3ulZfg-
Date: Tue, 12 Jun 2007 14:00:47 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Karl MacMillan <kmacmill@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070612190047.GA31041@vino.hallyn.com>
References: <20070514110607.549397248@suse.de> <200706110110.35553.agruen@suse.de> <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil> <200706111755.33162.agruen@suse.de> <20070611190222.GB18276@sergelap.austin.ibm.com> <1181653234.17547.89.camel@moss-spartans.epoch.ncsc.mil> <20070612153431.GB14397@sergelap.austin.ibm.com> <1181625438.18618.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181625438.18618.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Karl MacMillan (kmacmill@redhat.com):
> On Tue, 2007-06-12 at 10:34 -0500, Serge E. Hallyn wrote:
> > Quoting Stephen Smalley (sds@tycho.nsa.gov):
> 
> [...]
> 
> > > 
> > > If we added support for named type transitions to SELinux, as proposed
> > > earlier by Kyle Moffett during this discussion, wouldn't that address
> > > that issue without needing a DTE-like approach?  The concept is to add
> > 
> > Haven't read his message, but based on what you laid out here sure, that
> > sounds good.  It still, like my dte approach, might have some trouble
> > with the wildcard/regex rules AA allows.  And while it might perfectly
> > reproduce my original DTE behavior, I don't think it does what AA wants
> > on bind mounts.  (Whether what AA wants for bind mounts makes sense I'm
> > still not convinced, especially with user mounts coming soon (or already
> > here?), but I'm staying out of that discussion for now)
> > 
> > > the last component name as a further input to the labeling decision for
> > > new files, in addition to the existing use of the creating process'
> > > label, the parent directory label, and the kind of file.  Then, you
> > > could have something like:
> > > type_transition <domain> var_log_hosts_t:file "messages" messages_t;
> > > 
> > > The last component name is already available, so that doesn't require
> > > any changes to LSM, and it would be a straightforward extension of
> > > SELinux to support the above - it doesn't change the model at all, just
> > > adds a further input to the new file labeling logic.
> > 
> > And eliminates the need for restorecond?
> > 
> 
> Unlikely in the short term - restorecond is also used to reset contexts
> on critical files in /etc that might loose the context because tools
> used to update them are not correctly preserving contexts
> (e.g., /etc/mtab, etc/resolv.conf).

Confused - why wouldn't the new type_transition rule extension handle
that?

thanks,
-serge

> Actually - this whole notion restorecond as a critical component of
> SELinux because of a "new file problem" is pretty overblown. The default
> config file ships with:
> 
> /etc/resolv.conf
> /etc/samba/secrets.tdb
> /etc/mtab
> /var/run/utmp
> /var/log/wtmp
> ~/public_html
> ~/.mozilla/plugins/libflashplayer.so
> 
> So the only things that would be helped by type_transition rules with a 
> name component would be public_html and libflashplayer.so.
> 
> Karl
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
