Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYCLPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYCLPk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYCLPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:40:18 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:41639 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751252AbYCLPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:40:16 -0400
X-YMail-OSG: 0ioOVj8VM1nBoRfT9IyUndWRwgann.nHXaV6l_jj5B.Bbl5pUm22AniJ3oHOtDuVlg--
X-RocketYMMF: rancidfat
Date: Wed, 12 Mar 2008 08:40:15 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC][PATCH -v2] Smack: Integrate with Audit
To: Stephen Smalley <sds@tycho.nsa.gov>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>
In-Reply-To: <1205326375.23866.215.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <746579.84816.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> On Wed, 2008-03-12 at 04:44 +0200, Ahmed S. Darwish wrote:
> > Hi!,
> > 
> > Setup the new Audit hooks for Smack. The AUDIT_SUBJ_USER and 
> > AUDIT_OBJ_USER SELinux flags are recycled to avoid `auditd' 
> > userspace modifications. Smack only needs auditing on 
> > a subject/object bases, so those flags were enough.
> 
> Only question I have is whether audit folks are ok with reuse of the
> flags in this manner, and whether the _USER flag is best suited for this
> purpose if you are going to reuse an existing flag (since Smack label
> seems more like a SELinux type than a SELinux user).

To-mate-o toe-maht-o.

There really doesn't seem to be any real reason to create a new
flag just because the granularity is different. The choice between
_USER and _TYPE (and _ROLE for that matter) is arbitrary from a
functional point of view. I say that since Smack has users, but
not types or roles, _USER makes the most sense.

> Certainly will confuse matters if a user has audit filters on SELinux
> users in their /etc/audit/audit.rules and then boots a kernel with Smack
> enabled.

Somehow I doubt that will be their biggest concern.


Casey Schaufler
casey@schaufler-ca.com
