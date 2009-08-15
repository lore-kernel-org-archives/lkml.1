Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZHOXZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZHOXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 19:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZHOXZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 19:25:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:30152 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZHOXZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 19:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kwbbDrgZ2DYrsiJ/q1wv9lU98R7BupHdkaJjJywun5f4ZTdc+3cK3mewAiy0RTV60/
         QWaCk1NIKDYBpdzP3l2cWLaeIVSTu9iQegfg79e/HbQYuZHrAmcnFDXUAyVdAo6Oqqj4
         yZQy0J9MeTpJPH3jKMWv4Yu4TndRfqH4OqMEk=
MIME-Version: 1.0
In-Reply-To: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
Date: Sun, 16 Aug 2009 01:25:28 +0200
Message-ID: <6101e8c40908151625s52ad9b83ue061de3fab97fbf8@mail.gmail.com>
Subject: Re: Security: information leaks in /proc enable keystroke recovery
From: Oliver Pinter <oliver.pntr@gmail.com>
To: David Wagner <daw@cs.berkeley.edu>
Cc: freebsd-hackers@freebsd.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/09, David Wagner <daw@cs.berkeley.edu> wrote:
> At Usenix Security 2009, two researchers announced last week a new
> security vulnerability in multi-user Linux systems.  They demonstrated
> that one user can, in many cases, recover partial information about
> the keystrokes that another user types into applications running on
> that system.  For instance, they demonstrate how a malicious user can
> recover partial information about SSH passwords typed by other users,
> reducing the password search space by a factor of 250-2000x in
> their experiments.  Thus, this could facilitate password recovery.
>
> Question: Are there any plans to modify the Linux kernel to defend
> against this kind of attack?
>
> The paper is here:
>
> http://www.usenix.org/events/sec09/tech/full_papers/zhang.pdf
>
> In a nutshell, they exploit the fact that many files in /proc are
> world-readable yet contain sensitive information that can leak information
> about inter-keystroke timings.  For instance, /proc/$PID/stat reveals the
> ESP and EIP registers of the associated process, and is world-readable.
> /proc/pid/status is also mentioned as revealing information that could
> be exploited in these attacks.
>
> Based on my understanding of their work, it sounds like some of
> the information on those files should perhaps not be world-readable.
> It's not clear to me that it's reasonable for the kernel to reveal ESP,
> EIP, and other sensitive information about process behavior to everyone
> on the same system.
>
> Are folks already aware of these vulnerabilities?  Is there any work
> underway to try to address the issues identified in the Usenix Security
> paper?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

[snip]
6.2 Information Leaks in the Procfs of
       Other UNIX-like Systems
Besides Linux, most other UNIX-like systems also im-
plement procfs. These implementations vary from case
to case, and as a result, their susceptibilities to side-
channel attacks also differ. Here we discuss such privacy
risks on two systems, FreeBSD and OpenSolaris.
   FreeBSD manages its process ﬁles more cautiously
than Linux12 : it puts all register values into the ﬁle
/proc/pid/regs that can only be read by the owner
of a process, which blocks the information used by
our attack. However, we found that other informa-
tion released by the procfs can lead to similar attacks.
A prominent example is the system time reported by
/proc/pid/status, a ﬁle open to every user. Fig-
ure 11 shows the correlations between the time con-
sumed by vim and the keystrokes it received, as ob-
served in our research. This demonstrates that keystroke
events within the process can be identiﬁed from the
change of its system time, which makes keystroke eaves-
dropping possible. A problem here is that we may not
be able to detect special keys a user enters, for example,
“MOV CURSOR”, which is determined from ESP/EIP in-
formation on Linux. A possible solution is using the dis-
crepancies of system-time increments triggered by dif-
ferent keys being entered to ﬁngerprint these individual
keys. Further study of this technique is left to our future
research.
[/snip]
