Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXHIR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXHIR7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXHIR72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:59:28 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:32082 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752567AbXHIR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:59:27 -0400
X-YMail-OSG: aLq8HGMVM1niMzOcVkE9Yktwl8Bw6B6oLeiCbjyKYqhBXIqwz2yoOdviDSHWeajMLqAf7__0Gw--
X-RocketYMMF: rancidfat
Date: Thu, 9 Aug 2007 10:59:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1186680124.6916.624.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <803922.51849.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Thu, 2007-08-09 at 10:07 -0700, Casey Schaufler wrote:
> > --- David Howells <dhowells@redhat.com> wrote:
> > 
> > > Permit an inode's security ID to be obtained by the CacheFiles module. 
> This
> > > is
> > > then used as the SID with which files and directories will be created in
> the
> > > cache.
> > 
> > This is SELinux specific functionality. It should not be an LSM
> > interface. 
> 
> Odd, you proposed exactly the same hook (aside from naming convention
> and secid as argument vs. as retval) in recent postings on linux-audit
> and selinux list for use by the audit system.

And that's exposing SELinux specific functionality too. And I don't
like the fact that the audit system already requires a secid interface.
The audit system, however, does not use the secid for anything other
than a handle that gets passed around and eventually used to get the
data that goes into the audit record. It's annoying, but harmless and
does not affect any access control decisions. The change proposed here
would use the secid in access control decisions. The LSM interface
ought not to be exposing module specific internal data structures. My
work on pulling selinux code out of audit left the secid interface
in place. You're right in that audit should get fixed. I had been
hoping to make that a phase II activity.


Casey Schaufler
casey@schaufler-ca.com
