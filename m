Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZJFNm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZJFNm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZJFNm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbZJFNm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:42:56 -0400
Date: Tue, 6 Oct 2009 15:37:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091006133732.GB8628@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com> <20091006073100.4184128@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006073100.4184128@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Roland McGrath wrote:
>
> This whole series looks fine to me.  I think in commenting and cleaning up
> any of this, it bears explicit mention that (almost) every signal is
> potentially reduced to SI_USER.

Yes,

> but your logs and comments are not explicit about the relationship
> between that logic and what's implicit in the queue-exhaustion behavior.

Yes. the changelog for 3/4 mentions that this SI_USER doesn't really
mean SI_FROMUSER(), but I agree I should have been more explicit.

Perhaps, we should add the comment to explain that both SI_FROMUSER()
and si_fromuser() are only valid in the sending pathes. Fortunately
get_signal_to_deliver and friends do not care about the origination of
the signal.

Oleg.

