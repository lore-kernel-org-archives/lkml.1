Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbXFOSQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbXFOSQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXFOSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:15:56 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:43976 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204AbXFOSPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:15:55 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <230452.63481.qm@web36604.mail.mud.yahoo.com>
References: <230452.63481.qm@web36604.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 15 Jun 2007 14:15:30 -0400
Message-Id: <1181931330.17547.866.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 11:01 -0700, Casey Schaufler wrote:
> --- Greg KH <greg@kroah.com> wrote:
> 
> 
> > A daemon using inotify can "instantly"[1] detect this and label the file
> > properly if it shows up.
> 
> In our 1995 B1 evaluation of Trusted Irix we were told in no
> uncertain terms that such a solution was not acceptable under
> the TCSEC requirements. Detection and relabel on an unlocked
> object creates an obvious window for exploitation. We were told
> that such a scheme would be considered a design flaw.
> 
> I understand that some of the Common Criteria labs are less
> aggressive regarding chasing down these issues than the NCSC
> teams were. It might not prevent an evaluation from completing
> today. It is still hard to explain why it's ok to have a file
> that's labeled incorrectly _even briefly_. It is the systems
> job to ensure that that does not happen.

Um, Casey, he is talking about how to emulate AppArmor behavior on a
label-based system like SELinux, not meeting B1 or LSPP or anything like
that (which AppArmor can't do regardless).  As far as general issue
goes, if your policy is configured such that the new file gets the most
restrictive label possible at creation time and then the daemon relabels
it to a less restrictive label if appropriate, then there is no actual
window of exposure.

Also, there is such a daemon, restorecond, in SELinux (policycoreutils)
although we avoid relying on it for anything security-critical
naturally.  And one could introduce the named type transition concept
that has been discussed in this thread without much difficulty to
selinux.

-- 
Stephen Smalley
National Security Agency

