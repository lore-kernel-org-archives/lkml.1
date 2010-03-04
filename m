Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0CDQGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:06:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0CDQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:06:35 -0500
Date: Thu, 4 Mar 2010 08:06:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, wylda@volny.cz, gregkh@suse.de,
       jkosina@suse.cz, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead
 of force_sig()
In-Reply-To: <20100303202650.GA15521@redhat.com>
Message-ID: <alpine.LFD.2.00.1003040805550.7046@localhost.localdomain>
References: <alpine.LFD.2.00.1003021136400.3616@localhost.localdomain> <20100302201646.GA10734@redhat.com> <alpine.LFD.2.00.1003021223060.3616@localhost.localdomain> <20100303013227.4FFDE89EB@magilla.sf.frob.com> <alpine.LFD.2.00.1003021740560.3616@localhost.localdomain>
 <20100303112343.B89802F@magilla.sf.frob.com> <alpine.LFD.2.00.1003030930100.3627@localhost.localdomain> <20100303184412.GA7816@redhat.com> <alpine.LFD.2.00.1003031053050.3599@localhost.localdomain> <20100303193003.GA10734@redhat.com>
 <20100303202650.GA15521@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Oleg Nesterov wrote:
>
> zap_pid_ns_processes() uses force_sig(SIGKILL) to ensure SIGKILL
> will be delivered to sub-namespace inits as well. This is correct,
> but we are going to change force_sig_info() semantics.
> See http://bugzilla.kernel.org/show_bug.cgi?id=15395#c31
> 
> We can use send_sig_info(SEND_SIG_NOINFO) instead, since
> 614c517d7c00af1b26ded20646b329397d6f51a1 SEND_SIG_NOINFO means
> "from user" and therefore send_signal() will get the correct
> from_ancestor_ns = T flag.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

			Linus
