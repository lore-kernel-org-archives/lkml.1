Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZJDCbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZJDCbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 22:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZJDCbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 22:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZJDCa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 22:30:59 -0400
Date: Sun, 4 Oct 2009 04:25:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091004022556.GF21006@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021918.GB21006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Oleg Nesterov wrote:
>
> No changes in compiled code. The patch adds the new helper, si_fromuser()
> and changes check_kill_permission() to use this helper.
>
> The real effect of this patch is that from now we "officially" consider
> SEND_SIG_NOINFO signal as "from user-space" signals. This is already true
> if we look at the code which uses SEND_SIG_NOINFO, except __send_signal()
> has another opinion - see the next patch.
>
> The naming of these special SEND_SIG_XXX siginfo's is really bad imho.
> From __send_signal()'s pov they mean
>
> 	SEND_SIG_NOINFO		from user

To clarify, "from user" for SEND_SIG_NOINFO/SI_USER mean: sent by kernel
on behalf of some process. We should check permissions, sub-namespace,
we should fill si_pid/uid, etc.

Oleg.

