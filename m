Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928Ab0ACFiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab0ACFiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 00:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839Ab0ACFiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 00:38:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35875 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0ACFiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 00:38:14 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>
	<m1ws00uel9.fsf@fess.ebiederm.org> <4B4024A5.1020704@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 02 Jan 2010 21:38:05 -0800
In-Reply-To: <4B4024A5.1020704@kernel.org> (Tejun Heo's message of "Sun\, 03 Jan 2010 14\:01\:25 +0900")
Message-ID: <m1ljgfvjcy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> It's interesting that the above cases arn't common drivers.  AFAICS,
> the problem cases would usually be cases like above where the user is
> a rather complex software entity or drivers which implement some form
> of self detaching via sysfs.  For the former group, I agree that
> splitting deleting and draining (or simply skipping the draining part
> or active reference counting both of which basically achieve the same
> thing) would be an easy way out as it would be generally easy to leave
> the data structures dangling till the references go away.
>
> How about simply introducing an interface to mark sysfs nodes which
> don't require active reference counting and using them on those nodes?

That might work.  However it does not seem to address the case of
bond_sysfs, especially with someone doing rmmod bonding.

I think the brainstorm is on the right track.  I think we just need to look
at a few more cases in depth so that we can see a pattern and generalize
what can be done.

Eric
