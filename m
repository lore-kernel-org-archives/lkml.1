Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZICRZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZICRZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZICRZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZICRZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:25:13 -0400
Date: Thu, 3 Sep 2009 19:20:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sys_setrlimit: make sure ->rlim_max never grows
Message-ID: <20090903172052.GA27161@redhat.com>
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com> <20090902135024.GA6452@redhat.com> <4A9EBCF8.1020609@gmail.com> <20090902215101.GA4767@redhat.com> <4A9FC8DA.4090001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9FC8DA.4090001@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Jiri Slaby wrote:
>
> On 09/02/2009 11:51 PM, Oleg Nesterov wrote:
> > On 09/02, Jiri Slaby wrote:
> >> I can't think of anything else than doing all the checks and updates
> >> under alloc_lock, introducing coarse grained static mutex in setrlimit
> >> to protect it,
> >
> > Oh, please don't ;)
> >
> > Or I missed your point?
> >
> > But if you mean this series, then yes, I agree.
>
> Yes, I meant those. But I don't know what do you agree with :).

Not sure what I agree with, but I am glad we seem to agree with each other ;)

> > We should try to do something
> > to ensure that at least rlim_max can be always lowered when admin writes to
> > /proc/pid/limits.
>
> Yes, that's what I asked about when I wrote the three options which I
> was able to think of above. So any other ideas about how to elegantly
> protect against sys_setrlimit vs. admin+/proc/*/limits race?

Perhaps we should start these change with this patch (see the next email) ?

Perhaps, before your changes, we should "fix" sys_setrlimit() first ?
Well, the patch (the next email) is not tested... What do you think?

Oleg.

