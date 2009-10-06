Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZJFNYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZJFNYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZJFNYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZJFNYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:24:23 -0400
Date: Tue, 6 Oct 2009 15:18:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
Message-ID: <20091006131821.GA8628@redhat.com>
References: <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021954.GC21006@redhat.com> <20091005181255.GE30442@us.ibm.com> <20091005182536.GA943@redhat.com> <20091005193738.GF30442@us.ibm.com> <20091005194415.GA4560@redhat.com> <20091006000631.GA4390@us.ibm.com> <20091006010956.GA28233@redhat.com> <20091006023401.GA10132@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006023401.GA10132@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | On 10/05, Sukadev Bhattiprolu wrote:
> | >
> | > Oleg Nesterov [oleg@redhat.com] wrote:
> | > | Sorry for confusion.
> | > |
> | > | > But sure, we could use force_sig_info() in caller.
> | > |
> | > | Yes, because this makes the code more explicit imho. And we can avoid
> | > | the further complicatiions in send_signal() path.
> | >
> | > Although, one small drawback would be the different behavior for the
> | > SIGKILL in load_aout_binary() to the container-init itself calling:
> | >
> | > 	kill(getpid(), SIGKILL);
> |
> | could you clarify? load_aout_binary(), like other ->load_binary()
> | methods does send_sig(SIGKILL, current, 0) ?
>
> Yes sorry for being cryptic.
>
> If we use force_sig_info() in ->load_binary() methods for the SIGKILL,
> they will, correctly, kill the container-init.
>
> But if the container-init itself calls kill(getpid(), SIGKILL), the
> container-init will not be killed.

Ah, now I see what you mean.

Yes sure, init can't kill itself with or without these changes. But,
I think this is supposed behaviour which we do not want to change?


Oh. And I guess I misunderstood you before. From the previous email

> Makes sense. And we had mentioned earlier that container-init is immune
> to suicide

I guess this is what you meant, and I fully agree.

When I said "I disagree with container-init is immune to suicide",
I wrongly thought that you suggest that load_binary()->kill(SIGKILL)
should have no effect. I have to apologize for confusion again.

I hope we finally understand each other ;)

Oleg.

