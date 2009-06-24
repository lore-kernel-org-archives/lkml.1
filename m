Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbZFXQFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbZFXQFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZFXQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:05:11 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:48653 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753585AbZFXQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:05:09 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: fTv2TqkVM1kT_lvGa1_4zpHLIQnMLz2myKx6nRQkYfoT_pqlgfLthMCM7lB25ozNdGVov.H2NF1_ekXYgz3o4fzFb4yvBVfBpA0EYpUDLKUMHjnDhD2bdzGtan24HUtNozjM_7Ppu98y7CehRiX0EPLYm8TBsLsAiirqNzmYT75k97Aw4NslPmN4BImmQQtDz0a8nTnFbQuAZyMhuUOZnzclxrQrj.ZnltiAiTOZ6UoePvVSnTB2ZSOnuVev4ERkW__erk9lIKSWnKNS8fKjO0zCBYBnoXxHVAMjlJJ7Oo3X4cPO0zY8FFmYtZGhwGxPjCKX4uDKBFOTsPfk52KaMnOu4l9d5jY5pQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A424EA6.9020302@schaufler-ca.com>
Date: Wed, 24 Jun 2009 09:04:54 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Thomas <davidleothomas@gmail.com>
CC: linux-kernel@vger.kernel.org, LSM <linux-security-module@vger.kernel.org>
Subject: Re: Magic Security Dust: Appropriating SECCOMP
References: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
In-Reply-To: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Thomas wrote:
> "Code I trust processing data I don't" is a common situation.
>   

Please post patches. You might do well by posting to the LSM list
(cc:ed on this reply) before going to the LKML. As everyone knows,
the LSM list is not only the right place to start with security
proposals, but it's also the most cooperative and supportive.

Thank you.

> Web browsers, movie players, image viewers, document readers,
> video games, and many other applications deal with data
> that could be malicious.  I was looking for an easy way to
> restrict the damage my software might do should my handling
> of malicious data be less than perfect.  The options I found,
> under Linux, were SECCOMP and ptrace.  SECCOMP seemed much too
> narrow, while ptrace seemed more complicated than I needed and
> also incurs a performance penalty.  So I modified SECCOMP as
> described below, and have been running on this kernel since
> November with no apparent issues or change in performance.
> I was wondering what thoughts people had, before I updated
> the patch to the latest kernel.
>
> For those unfamiliar, SECCOMP allows a process to restrict
> the set of syscalls it can later access through a flag set
> with prctl.
>
> While SECCOMP originally worked from "modes" with lists of
> allowable syscalls, I thought it better to have a set of
> flags.  There were two reasons for this.  First, it allows
> easier checking of whether a syscall should be permitted
> (a simple bitwise-and).  Second, I find it easier to reason
> about composing groups of syscalls than remembering precisely
> what is permitted/denied in a list of modes.  As there was
> previously only a mode 1, having flag zero provide the same
> syscalls maintains backwards-compatibility.
>
> Moving the checks from the audit/trace code out to the
> individual syscalls means that each syscall we're doing one
> check and a correctly predicted branch, instead of n checks
> with (usually) a mis-predicted branch.  This also means greater
> granularity at build time - rather than merely "SECCOMP or no
> SECCOMP", an individual build can check the flags for open and
> fork but not for read and write, or any other combination.
> Because no process will be relying on these checks to *add*
> functionality, this will be completely transparent to user-space
> and can be configured as best suits the individual deployment,
> balancing the users' paranoia against their need for speed.
>
> This is not meant to replace SELINUX, jails, or other
> security mechanisms, but to supplement them.  This makes it
> easier for a developer to limit the damage a process might
> unintentionally do, regardless of the setup of the end user.
> Lest anyone get the wrong idea, "magic security dust" is of
> course tongue-in-cheek - security issues require thought and
> care with or without this patch.  This just seems another tool
> which attacks these issues from a slightly different direction.
>
> Specific points for further discussion, if this is something
> people are interested in:
>
> * Which syscalls are grouped under what flags, and what
> appropriate names for those flags might be.  Bear in mind that
> starting from an over-constrained set of flags provides a better
> path forward, as we won't be breaking anything that worked
> before if we add new flags or new syscalls to existing flags.
>
> * What to do during fork or exec when permitted - note that no
> decision is reflected in the code I already have, as there's
> presently no flag that permits either of these.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
