Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZD2K3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZD2K3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZD2K3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:29:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZD2K3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:29:09 -0400
Date: Wed, 29 Apr 2009 12:25:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429102511.GA10767@redhat.com>
References: <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <7242.1240999370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7242.1240999370@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > we can flush the signal which was sent after we changed SID/cred and passed
> > the new permission checks,
>
> I think you mean to say, rather, that we can *lose* a signal that was sent,
> because flush_signals() discards all pending signals unconditionally, and so
> SIGKILL can be lost?

Yes, thanks.

> I suspect we should pass SIGKILL

Or we can fliter out SIGKILLs, yes.

But this doesn't differ from "do nothing if SIGNAL_GROUP_EXIT", except needs
a bit more changes. If SIGNAL_GROUP_EXIT is true, we must have a pending
SIGKILL. Either way the task never returns to user-space.

> and possibly SIGSTOP through the flush.

Yes, perhaps... But I don't know if this is right from the selinux pov.
Perhaps it was queued before we changed SID.

And. It is possible that the task/user who sent SIGSTOP before changing
SID will not able to send SIGCONT later.

Oleg.

