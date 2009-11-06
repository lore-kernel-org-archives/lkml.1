Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZKFKAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZKFKAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 05:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZKFKAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 05:00:49 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50353 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbZKFKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 05:00:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rSnoTp2Hka3BnV1wKkY1Y5F+gK1rYQCgcf/nPnllUZcaWKhf3+osep3XJQyT8I51LW
         e5vIZvwwtqSrqvPcm40JWFIP7b+j403nxRbP16GMeV9uPycO3iChAiZP5vqsmYSt43WC
         jYkFSFNWQtJ/wdsow6/Vg+HL8QLKIcRTIhcSU=
Message-ID: <4AF3F3CF.5080503@gmail.com>
Date: Fri, 06 Nov 2009 11:00:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu>
In-Reply-To: <20091106092600.GC22505@elte.hu>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 10:26 AM, Ingo Molnar wrote:
> Jiri, i think your patches are incomplete for the same reasons i 
> outlined to Neil.

I'll examine that. Thanks for pointing out.

> Also, the locking there looks messy:
> 
> +       /* optimization: 'current' doesn't need locking, e.g. setrlimit */
> +       if (tsk != current) {
> +               /* protect tsk->signal and tsk->sighand from disappearing */
> +               read_lock(&tasklist_lock);
> +               if (!tsk->sighand) {
> +                       retval = -ESRCH;
> +                       goto out;
> +               }
>         }
> 
> Neil's splitup into a helper function looks _far_ cleaner.

Then, I think, we should join our efforts.

> I'm also wondering, how did these commits get into linux-next? It 
> appears that that the 'writable_limits' tree got added by sfr to 
> linux-next on Oct 26 just based on Jiri's request, without acks/review 
> from the people generally involved with this code.

I posted the patches three times. The first, we discussed with Oleg
Nesterov the whole thing (with you in CC btw) and I resent changed code
(v2) based on Oleg's input. Then, after a month and a half I reposted
whole patchset simply because nobody cared/commented. Waited another 10
days and got pissed off (that I'm ignored for no obvious reason) so that
I asked Stephen (publicly) to include it in the -next. He did, I
wouldn't say it's all his fault. I must add that selinux security guys
cooperated with me on the first patches.

I hoped for anybody's raised voice: nobody's :(. Is there anything I did
wrong? Who are the people to get an ACK from in this case?

Thanks.
