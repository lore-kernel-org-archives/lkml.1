Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYLDOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYLDOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLDOfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:35:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYLDOfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:35:41 -0500
Date: Thu, 4 Dec 2008 15:34:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andi Kleen <ak@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081204143409.GA10384@redhat.com>
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com> <20081201123405.51d20d84@bike.lwn.net> <20081202122939.GA3619@redhat.com> <493562B5.5020600@linux.intel.com> <20081203190648.GA23893@redhat.com> <4936F83E.7090506@linux.intel.com> <20081203154508.3502b365@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203154508.3502b365@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Jonathan Corbet wrote:
>
> On Wed, 03 Dec 2008 22:21:02 +0100
> Andi Kleen <ak@linux.intel.com> wrote:
>
> > > Serioulsy, I think the best (partial, yes) fix for now is to restore
> > > lock_kernel() in setfl() and change ioctl_fioxxx() accordingly.
> > > At least this protect us from tty too.
> >
> > For 2.6.28 I agree.
>
> OK, what do you all think of the following?  It returns fcntl.c to its
> previous state, and adds locking in fs/ioctl.c.  It's worth noting that
> ioctl_fioasync() has always been racy in exactly the same way.

Yes, I agree with you and Andi, imho this is what we need for 2.6.28.

Thanks Jonathan!

Oleg.

