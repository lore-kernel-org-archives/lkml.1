Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbXFVQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbXFVQGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbXFVQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:06:09 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:32834 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757887AbXFVQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:06:08 -0400
X-YMail-OSG: xrTLOKEVM1kKElC.BjlxCHYvmM2Tz2Bp52GCB4fkPbjBhwDlZM9jGqjG9WgT7X83lPeEh9WJPw--
X-RocketYMMF: rancidfat
Date: Fri, 22 Jun 2007 09:06:06 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1182516111.24664.72.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <981505.42017.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

 
> Mandatory access control as historically understood has always meant
> system-wide.

Chapter and verse: TCSEC 3.1.1.4 Mandatory Access Control
  "The TCB shall enforce a mandatory access control policy over
   all subjects and storage objects under its control."

Chapter and verse: TCSEC 3.2.1.4 Mandatory Access Control
  "The TCB shall enforce a mandatory access control policy over
   all resources that are directly or indirectly accessible by
   subjects external to the TCB."

The first reference is in the definition of a B1 system, while the
second is for a B2 system. It was made clear to those of us
doing TCSEC evaluations that there is a very real distintion between
these two requirements. In the history that I've been through,
starting in 1987, the B1 requirement has been read to allow for
things that are not storage objects to be uncontrolled while the
B2 requirement does not. If everything is a storage object, which
is the approach everybody took, yes, you're looking at system wide.
If, on the other hand, you were to take a different model approach
and say that networking does not use storage objects you would not
have to account for them under the B1 rules, while you would still
have to for B2. Historically, no one succeeded with B2, and the
mindset of B1 prevailed. So, historically, the understanding was
that it was easier to declare everything a storage object and code
up some MAC for it than it was to provide a security model that
explained networking as it really works. I suggest that if AA wants
to declare that as far as they are concerned sockets, ports, and
packets are none of them storage objects but are instead pregnant
weasels that is their peragotive as system designers and that
a B1 evaluation team would have accepted that, provided sufficient
evidence and explaination of the relevence of pregnant weasels
was provided. It would not have worked at B2, but historically
everyone understood that B2 was out of reach.

Stephen is correct in that historically everyone implemented system
that put everything under MAC, but is not in that it was well
understood that if you could define something as not being a
storage object you didn't have to submit it to MAC. Then as now
it was easier to get people to code MAC than to get them to write
papers about the security properties of pregnant weasels.



Casey Schaufler
casey@schaufler-ca.com
