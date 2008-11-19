Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYKSBZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYKSBZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYKSBZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:25:41 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56005 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYKSBZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:25:40 -0500
Date: Tue, 18 Nov 2008 17:22:07 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][v2] Define/use siginfo_from_ancestor_ns()
Message-ID: <20081119012207.GA19092@us.ibm.com>
References: <20081115212133.GA32140@us.ibm.com> <20081118175336.GA14178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118175336.GA14178@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


| 
| > +static inline int siginfo_from_ancestor_ns(siginfo_t *info)
| > +{
| > +	return SI_FROMUSER(info) && (info->si_pid == 0);
| > +}
| 
| Yes, this is problem... I doubt we can rely on !si_pid here.
| More on this later.

BTW, rather than clearing SIG_FROM_USER in send_signal(), can we
keep it till we dequeue the signal ? Yes, collect_signal() would
need to consider this flag. But when we dequeue, we can note that
it was from user and use that in the siginfo_from_ancestor() ?

Sukadev
