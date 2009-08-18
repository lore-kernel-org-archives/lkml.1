Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZHRMM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZHRMM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbZHRMMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:12:55 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:34546 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbZHRMMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:12:54 -0400
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
From: Stephen Smalley <sds@tycho.nsa.gov>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <87y6pha7vv.fsf@devron.myhome.or.jp>
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	 <20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	 <1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
	 <87prau5ld1.fsf@devron.myhome.or.jp>
	 <1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>
	 <873a7q441a.fsf@devron.myhome.or.jp>
	 <1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>
	 <87fxbq19qs.fsf@devron.myhome.or.jp> <87my5yxidt.fsf@devron.myhome.or.jp>
	 <87y6pha7vv.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 18 Aug 2009 08:15:42 -0400
Message-Id: <1250597742.3629.205.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 16:39 +0900, OGAWA Hirofumi wrote:
> [Sorry if this killed thread. My ISP seems to be stopping email server
> now. I've read this email from web archive.]
> 
> >> @@ -2711,12 +2711,17 @@ static int selinux_inode_permission(stru
> >>  static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
> >>  {
> >>  	const struct cred *cred = current_cred();
> >> +	unsigned int ia_valid = iattr->ia_valid;
> >>  
> >> -	if (iattr->ia_valid & ATTR_FORCE)
> >> -		return 0;
> >> +	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
> >> +	if (ia_valid & ATTR_FORCE) {
> >> +		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE);
> >> +		if (!ia_valid)
> >> +			return 0;
> >>   
> > 
> > So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
> > not return here, since 'ia_valid' will be ATTR_FORCE finally.
> > 
> > I think you forgot to clear ATTR_FORCE here...
> 
> Whoops, good catch. Fortunately, it doesn't seem to have actual problem,
> but it's bug obviously, and sorry for that. Fixed patch was attached.

You can add my:
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

-- 
Stephen Smalley
National Security Agency

