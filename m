Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbXLLTue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbXLLTue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXLLTuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:50:24 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:42597 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbXLLTuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:50:23 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <830252.82380.qm@web36604.mail.mud.yahoo.com>
References: <830252.82380.qm@web36604.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 12 Dec 2007 14:49:06 -0500
Message-Id: <1197488946.1125.151.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 11:44 -0800, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > > What sort of authorization are you thinking of? I would expect
> > > that to have been done by cachefileselinuxcontext (or
> > > cachefilesspiffylsmcontext) up in userspace. If you're going to
> > > rely on userspace applications for policy enforcement they need
> > > to be good enough to count on after all.
> > 
> > It can't be done in userspace, otherwise someone using the cachefilesd
> > interface can pass an arbitrary context up.
> 
> Yes, but I would expect that interface to be protected (owned by root,
> mode 0400). If /dev/cachefiles has to be publicly accessable make it
> a privileged ioctl.

Uid 0 != CAP_MAC_OVERRIDE if you configure file caps and such.

> > The security context has to be
> > passed across the file descriptor attached to /dev/cachefiles along with the
> > other configuration parameters as a text string.
> 
> I got that.
> 
> > This fd selects the
> > particular cache context that a particular instance of a running daemon is
> > using.
> 
> Yes, but forgive me being slow, I don't see the problem.
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com
-- 
Stephen Smalley
National Security Agency

