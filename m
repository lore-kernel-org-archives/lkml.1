Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXLLUJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXLLUJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXLLUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:09:44 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:45864 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754230AbXLLUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:09:43 -0500
X-YMail-OSG: L1QPsasVM1mtVXzaQCZ3_XrX.BPVBxb.t1mlgVkwn6lhfXtZnAAUJYvnHBIUqtPswji4XmcBYw--
X-RocketYMMF: rancidfat
Date: Wed, 12 Dec 2007 12:09:42 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1197488946.1125.151.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <483979.69273.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Wed, 2007-12-12 at 11:44 -0800, Casey Schaufler wrote:
> > --- David Howells <dhowells@redhat.com> wrote:
> > 
> > > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > 
> > > > What sort of authorization are you thinking of? I would expect
> > > > that to have been done by cachefileselinuxcontext (or
> > > > cachefilesspiffylsmcontext) up in userspace. If you're going to
> > > > rely on userspace applications for policy enforcement they need
> > > > to be good enough to count on after all.
> > > 
> > > It can't be done in userspace, otherwise someone using the cachefilesd
> > > interface can pass an arbitrary context up.
> > 
> > Yes, but I would expect that interface to be protected (owned by root,
> > mode 0400). If /dev/cachefiles has to be publicly accessable make it
> > a privileged ioctl.
> 
> Uid 0 != CAP_MAC_OVERRIDE if you configure file caps and such.

Yes, but we're talking about writing the configuration information
to the kernel, not actually making any access checks with it. I
think. What I think we're talking about (and please correct me David
if I've stepped into the wrong theatre) is getting the magic
secctx that cachefiles will use instead of the secctx that the task
would have otherwise. I don't think we're talking about recomputing
it on every access, I think David is looking for the blunderbuss
secctx that he can use any time he needs one.

And it would be CAP_MAC_ADMIN, since you're changing the MAC
characteristics of the system, not doing an access check.

Casey Schaufler
casey@schaufler-ca.com
