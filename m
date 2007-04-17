Return-Path: <linux-kernel-owner+w=401wt.eu-S1161291AbXDQU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291AbXDQU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXDQU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:26:37 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:46336 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161291AbXDQU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:26:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 16:26:35 EDT
X-YMail-OSG: Y5a.MGcVM1mia.24v3DjvjZaGF9VcRj1pQ1NsYjx1nUQGm.O7S22Ml5IzBxNAkWLUYGfo0EBdA--
X-RocketYMMF: rancidfat
Date: Tue, 17 Apr 2007 13:19:54 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: AppArmor FAQ
To: Andi Kleen <andi@firstfloor.org>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070417181016.GA10903@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <657751.18080.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Apr 17, 2007 at 01:47:39PM -0400, James Morris wrote:
> > Normal applications need zero modification under SELinux.
> > 
> > Some applications which manage security may need to be made SELinux-aware, 
> 
> Anything that can touch /etc/resolv.conf? That's potentially a lot of
> binaries
> if you consider anything scripts could do with it.

Well, no, you don't have to modify everything that might modify resolv.conf.
You do have to define your policy so that the set of things that might
modify resolv.conf is limited to the set of things that are appropriate.

You also need to note that SELinux has a notion of privilege that is
different from what is traditional. The ability to modify resolv.conf
is determined by the domain containing it and the relationship of the
domain containing the application to that domain, modified by any
domain transitions that may have occured to the process prior to or
during the attempted access.

> > although this can often be done with PAM plugins, which is a standard way 
> > to do this kind of thing in modern Unix & Linux OSs.
> 
> PAM plugins in vi and emacs? Scary idea.
> 
> And what do you do if someone decides to use OpenOffice to edit their
> /etc/resolv.conf? For a lot of people that's the only text editor 
> they know.

For SELinux to be effective it has to have a complete policy definition.
This would prevent the OpenOffice access (unless OpenOffice is in the
modify_resolv_conf_t domain) above.

This, by the way, is a fundimental advantage of a path scheme over a
label scheme in that label schemes require every object be labeled
(it's Section 3.1.1.3 of the TCSEC if you want to look it up) while a
path scheme (in the absences of a published requirement) only requires
those names it cares about. SELinux in the absence of a correct and
complete policy could be considered dangerous.


Casey Schaufler
casey@schaufler-ca.com
