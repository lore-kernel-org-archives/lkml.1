Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbYB2BUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbYB2BUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYB2BUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:20:37 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:57685 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYB2BUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:20:35 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <177491.29492.qm@web36613.mail.mud.yahoo.com>
References: <177491.29492.qm@web36613.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 19:52:59 -0500
Message-Id: <1204246379.2715.52.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 17:04 -0800, Casey Schaufler wrote:
> --- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > 
> > ...
> > 
> > I can only speak for myself but honestly I've only seen Casey act
> > confrontational to this idea from the beginning.
> 
> That is simply because I don't care for your design and implementation
> choices, I think they're a bad way to go, I've suggested what I
> think you should do, and I'm sorry that that comes off as
> confrontational but that does not change what I see as flaws in
> your approach. I understand what you're trying to do and I think
> it's wrong.
> 
> > There is absolutely
> > nothing in here that is SELinux specific, tecnically its not even MAC
> > specific.
> 
> Then why are you putting "mac" in the interface name?
> 
> > I said from the beginning that this was perhaps not the best
> > name and we are willing to change it.
> 
> If you read back in the thread, that is what I suggested you do.

I know but for some odd reason we kept arguing about it. Unless you want
me to repost the patch on it's own with the name changed you are going
to have to wait for version two :)

> 
> > There is nothing in this hook that
> > wasn't in LSM before. This is almost identical functionality to what
> > Adrian removed in 2.6.24. The only difference between this and
> > security_inode_getsuffix is that this returns security.suffix and that
> > the name is different. I don't have a SMACK box to test it on but I'm
> > 99% sure that if Casey tried to use SMACK with this patch set that he
> > would have labeled nfs working with SMACK.
> 
> You're very possibly right. I am not argueing from what's right for
> Smack, I am argueing from what's right for the LSM. Smack is a label
> based MAC LSM, like SELinux. I would expect that it would be easy for
> the NFS implementation to accomodate both.
> 
> > If it doesn't work with SMACK
> > right now I'm willing to help him with that and even include it in the
> > patch set. But spreading FUD about how we are including SELinux specific
> > code in here is just that.
> 
> Sorry, but I'm not argueing that it's SELinux specific at this point.
> I'm argueing that it's specific to single label stored in an xattr
> based MAC systems (a set of which both SELinux and Smack are members)
> and that it is file system specific to NFS. Any of these attributes
> makes it questionable as an LSM interface.
> 
> As I said before, trying to be helpful, call it security_blob_name(),
> and the upcoming Discretionary Time Lock module can return NULL,
> indicating that it wants to share no blob name. Or call it
> security_xattr_names() and DTL can return NULL and B&L+Biba can
> return "security.Bell&LaPadula security.Biba", hoping that everyone
> who uses the interface accepts the blank seperation as an indication
> that there are multiple xattrs involved.

I agree with your suggestion here but nowhere in earlier emails did you
outline this. You just vaguely described a method that sounds like the
selinux sidtab. If you had described it this way in the beginning we
would have be done with after the first response. If we are going to
work well in the future you need to be more clear when you make
constructive criticisms (or even destructive ones *wink* ).

> 
> I am saying that security_maclabel() is a bad choice, and I think
> that as an LSM (not MAC, not xattr, not NFS) interface it should
> serve the LSM, making the LSM interface better first, and being
> the specific interface that a particular file system finds
> convenient second.
> 
> And before we go any further, I have personally been involved in
> doing labeled NFS three times, and I know where the bodies are
> buried. Your approach is fine for single label stored in xattr based
> MAC systems. It does not generalize worth catfish whiskers, whereas
> the two other schemes I've done do so flawlessly. I am critical of
> this approach only because I know that y'all can do better.

That is fine. I welcome constructive criticism but you have a tendency
of being vague with what you mean and at times it comes off the wrong
way. This is the whole reason the patch set was posted to begin with. We
have been working on it for so long without much outside input so we
decided to get criticism on it.

> 
> Great. Now I owe the entire labeled NFS team beer.
> 
> Thank you.
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com

