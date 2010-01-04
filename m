Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942Ab0ADTQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0ADTQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920Ab0ADTQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:16:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36578 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0ADTQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z9o41eytqMInrgDxr5+idtIR51ANfJaDuhBEE8CB5IcvHkrnbsThsq6MCxTCRuVvNZ
         iULbz9aFAdgmi+mBRxhWJ+9bYB3TGSMGb9k3+V/xPtQJjh1cHfqjS+ZtsH/O2XJD0KfX
         O5nk/xjCULArs2Da3MKceRIrdePVaZsEwsEDQ=
Date: Mon, 4 Jan 2010 11:16:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
Message-ID: <20100104191606.GC2597@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
 <m1fx6rtu31.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
 <m11vi9c0td.fsf@fess.ebiederm.org>
 <4B3EB687.7000005@kernel.org>
 <m17hs0xjmn.fsf@fess.ebiederm.org>
 <4B3FE586.7020109@kernel.org>
 <20100103074745.GA2314@core.coreip.homeip.net>
 <m1tyv3sbg4.fsf@fess.ebiederm.org>
 <m1d41rsanp.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d41rsanp.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 03:14:18AM -0800, Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> > What to do about it is another question.   It has just recently come to my
> > attention that we have more events like this
> 
> In the specific case of serio what gets us in trouble is
> the call to sysfs_remove_group.
> 
> If instead of independent calls to sysfs_create_group/sysfs_remove_group,
> you could move the groups into a list on dev->groups than we could solve
> two problems.
> 
> - Userspace would see all of the attributes when the hotplug event is
>   fired remove races.
> 
> - We would not hold serio->drv_mutex over sysfs_remove_group so there
>   would not be a possible deadlock on device removal.
> 
> Does that change sound possible?

No, because attributes in question belong to driver+device combo. The
device will not go away when driver is unbound but we do want to remove
attributes.

-- 
Dmitry
