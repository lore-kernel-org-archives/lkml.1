Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZKIRP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZKIRP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZKIRP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:15:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:50023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZKIRPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=eBFGSIVNhggtI1ot5BwJLN9KtBulIVTIeztnuWzGHktNqXT6tC2QpkZ2GrycI7Nm4F
         w+0qg5RD+rErKhiFMtiS5XqV2I0uIKVW2/Z/9h2jSD5K+p1sClGqwQzzugKHvFIRdSi+
         n2IByDD8mqoHGL+EtfwZokva34akuv48xmVUU=
Message-ID: <4AF84E2F.3010305@gmail.com>
Date: Mon, 09 Nov 2009 18:15:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com>
In-Reply-To: <20091109164053.GB5160@redhat.com>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 05:40 PM, Oleg Nesterov wrote:
> Also, I don't understand why wthis code get's both pid and task_struct().

And what do you suggest? I, with my knowledge and after fast
investigation, see no other option.

> And the "if (resource >= RLIM_NLIMITS)" check is racy afaics, see
> http://marc.info/?l=linux-kernel&m=125200862124872

Your patch (which I have in my series btw) is likely needed for the
setprlimit syscall, having this on my mind again from now on. But the
'if' above is a different story. 'resource' is an index here.

And as a bonus, what I found out now is that /proc/*/limits
(proc_info_read->proc_pid_limits) doesn't necessarily reflect current
limits. Since task_lock(current->group_leader) is not held, values of
one limit may be from the old as well as the currently updated one.

Am I right and do we care at all (since it's not atomic anyway in the
sense of reading 2 small chunks from that file)?

Thanks for the input.
