Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYDKHOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYDKHOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbYDKHOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:14:16 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:2997 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbYDKHOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=agMpJBIS9YqqGCNBsR3abyLxK1LKtIAC1/7wwq6oe1Jqb/jMZ0ZKRSydx73NcQ7Ywxe23/94u7EKYGRCYdyau1ts9O9rFe0b2lyBUCQGq0BwdLq4J2x2TDlo4zPYoby+hO9wtIz+RUVwq6VRZJgy37C+0dne/+6NoraW+O1gUzI=
Message-ID: <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
Date: Fri, 11 Apr 2008 00:14:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  > last week found:
>  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  > forcedeth doesn't work anymore.
>  >
>  > I stared at forcedeth.c two days. and revert every patches about that
>  > doesn't help.
>
>  So forcedeth does not come up again, when you kexec from linus.git
>  into an older distro kernel. Or is it the other way round ?
RHEL 5.1 kexec RHEL 5.1 : works
RHEL 5.1 kexec linus kernel: works
linus (after -rc2) kexec linus tree: works:
linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
linus ( before -rc2 include rc2) kexec RHEL 5.1 works

>
>  Does a non kexec boot work ?

Yes

>
>
>  > and figure out 2.6.25-rc2 works.
>  >
>  > with git-bisect found
>  >
>  > commit 89d694b9dbe769ca1004e01db0ca43964806a611
>  > Author: Thomas Gleixner <tglx@linutronix.de>
>  > Date:   Mon Feb 18 18:25:17 2008 +0100
>  >
>  >     genirq: do not leave interupts enabled on free_irq
>  >
>
> > caused the regression.
>  >
>  > it affected all my servers that are using Nvidia MCP55.
>  >
>  > maybe we need to revert that patch.
>
>  Which causes an interrupt storm on the enabled irq line, when the
>  interrupt line is still active for whatever reason. So we trade one
>  badness vs. the other.
>
>  Reverting the patch is not going to give us any answer about the real
>  problem.

but that interrupt storm bug already happend from .21 to .24

>
>  Is there anything in dmesg, which might give us an hint about that ?

everything looks normal.

YH
