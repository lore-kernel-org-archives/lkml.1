Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994Ab0AAPeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0AAPeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AAPeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:34:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51832 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0AAPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hSN6F6kuzZcGiNm6tuN/LnfwzpoI8WCTAw+JjH3/TinrMJM1Zcb1OCcyKphZ0pGOok
         NdZd7ZGL+C85xxsVoEBDKpiB6Hje/UUfVp5BIbOR9PImc4yLETlkEUpuRZbU/L4jhiAG
         B7POdh0dofgR3PdcWjesCrBnW9PEIyoqWbO0k=
Date: Fri, 1 Jan 2010 16:33:53 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir
 scalability
Message-ID: <20100101153353.GA2572@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	David Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091226094504.GA6214@liondog.tnic>
 <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
 <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
 <m1fx6rtu31.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
 <m11viaexlj.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m11viaexlj.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 05:58:00AM -0800, Eric W. Biederman wrote:
> 
> When sysfs_readdir stops short we now cache the next sysfs_dirent to
> return to user space in filp->private_data.  There is no impact on the
> rest of sysfs by doing this and in the common case it allows us to
> pick up exactly where we left off with no seeking.
> 
> Additionally I drop and regrab the sysfs_mutex around filldir to avoid
> a page fault arbitrarily increasing the hold time on the sysfs_mutex.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
> 
> I haven't stressed this patch but it is sound in principle, and is a
> general sysfs improvement, regardless of any locking issues.

I've slapped it ontop of v2.6.33-rc2-249-gcd6e125 here and the circular
locking warning is gone. I'll keep an eye on it in the next couple of
days, just in case.

Tested-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
