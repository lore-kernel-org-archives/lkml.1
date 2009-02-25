Return-Path: <linux-kernel-owner+w=401wt.eu-S1763176AbZBYXvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763176AbZBYXvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZBYXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:50:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZBYXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:50:58 -0500
Date: Wed, 25 Feb 2009 17:54:09 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit_notify: kill the wrong capable(CAP_KILL) check
Message-ID: <20090225235409.GA2443@hallyn.com>
References: <20090225190218.GA7453@redhat.com> <20090225194140.D6F6EFC3DA@magilla.sf.frob.com> <20090225215356.GA1442@hallyn.com> <20090225220324.GA14667@redhat.com> <20090225221415.GA1751@hallyn.com> <20090225223234.GA16156@redhat.com> <20090225224751.GA2062@hallyn.com> <20090225231645.GA17868@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225231645.GA17868@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 02/25, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 02/25, Serge E. Hallyn wrote:
> > > >
> > > > Quoting Oleg Nesterov (oleg@redhat.com):
> > > > > On 02/25, Serge E. Hallyn wrote:
> > > > > Can't understand... Why do you think CAP_KILL makes things better?
> > > > >
> > > > > Actually, how can it make any difference in this case?
> > > >
> > > > Well the check by itself isn't quite right - it seems to me it
> > > > should also check whether tsk->euid == parent->uid.  But letting
> > > > an unprivileged task send SIGSTOP to a privileged one bc of
> > > > some fluke in the task hierarchy doesn't seem right.
> > >
> > > I think you misread this CAP_KILL check.
> > >
> > > It does not restrict the unprivileged task to send the signal. Instead,
> > > if the exiting task has CAP_KILL, we bypass other security checks.
> >
> > ?  If the exiting task does not have CAP_KILL,
> 
> _and_ (not "or") the execution domains for parent/chils are different,
> 
> > we set the signal to
> > SIGCHILD (which is deemed safe).
> 
> Yes. So why we should not set the signal to SIGCHLD if the task has
> CAP_KILL ?

Yeah, you're right,  I wasn't thinking right.

> And again, the malicious application can exec the setuid binary before
> exit, in this case we never reset ->exit_signal (of course, unless
> that binary drops CAP_KILL).

Heh, thanks for taking the time to set me straight.

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks.

-serge
