Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZGCLao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZGCLao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZGCLad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:30:33 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:59811 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZGCLac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:30:32 -0400
X-Greylist: delayed 19095 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 07:30:32 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vRrZBRMKZljcdq+dp61lcPMPY+VF/FqIVnoIAeXM83OWlCia6EHgmVArf8QzUL+cV1
         Wp7OJsE0wQumCMie9095B+xKjPADY18PUfb1UzwoLn76q1JDugSNVTDeQ07XqiI1ozLZ
         rXHtooOCuBgsjsqmdTeM/ejk0f4MqMUDRRVuA=
Date: Fri, 3 Jul 2009 11:30:27 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703113027.GC4847@ff.dom.local>
References: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com> <20090703081445.GG2902@jolsa.lab.eng.brq.redhat.com> <20090703090606.GA3902@elte.hu> <4A4DCD54.1080908@gmail.com> <20090703092438.GE3902@elte.hu> <20090703095659.GA4518@jolsa.lab.eng.brq.redhat.com> <20090703102530.GD32128@elte.hu> <20090703111848.GA10267@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703111848.GA10267@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 01:18:48PM +0200, Jiri Olsa wrote:
...
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index b7e5db8..4e77853 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
...
> @@ -1271,6 +1271,9 @@ static inline int sk_has_allocations(const struct sock *sk)
>   * in its cache, and so does the tp->rcv_nxt update on CPU2 side.  The CPU1
>   * could then endup calling schedule and sleep forever if there are no more
>   * data on the socket.
> + *
> + * The sk_has_helper is always called right after a call to read_lock, so we
Btw.:
- * The sk_has_helper is always called right after a call to read_lock, so we
+ * The sk_has_sleeper is always called right after a call to read_lock, so we

Jarek P.
