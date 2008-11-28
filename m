Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYK1V6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYK1V6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYK1V6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:58:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:21720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYK1V6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=kZQOE0lU9pnM5JmAomAPpn5tgCmSOtKymV+pMDAZG1Tza/axlZ/+3yYfnZKkUR0IQI
         LG0jRH2d0D1iQv1dcCzplVoMyqVeuS41aumrG5MjWMLLr5eQePQxD4Xg/DADWslGx2FP
         B49B4uC+crPizypO3UD4OwbrnIBgiBo+9Jkvo=
Message-ID: <cfd18e0f0811281358s2e831b04qc56277db403c2039@mail.gmail.com>
Date: Fri, 28 Nov 2008 16:58:00 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: Nadia.Derbey@bull.net
Subject: Re: signal handling description for Michaels CLONE_NEWPID man page
Cc: serue@us.ibm.com, sukadev@us.ibm.com, xemul@openvz.org, kir@openvz.org,
       linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081127070806.626288939@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081127070720.954560982@bull.net>
	 <20081127070806.626288939@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadia,

Thanks for putting this together.  A few questions below.

On Thu, Nov 27, 2008 at 2:07 AM,  <Nadia.Derbey@bull.net> wrote:
> Michael,
>
> Here is the proposal for a description of signals handling in pid
> namespaces.
>
> This applies on top of your CLONE_NEWPID patch.
>
> Regards,
> Nadia
>
> ---
>  man2/clone.2 |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> Index: man-pages-3.13/man2/clone.2
> ===================================================================
> --- man-pages-3.13.orig/man2/clone.2    2008-11-24 09:34:30.000000000 +0100
> +++ man-pages-3.13/man2/clone.2 2008-11-27 09:17:53.000000000 +0100
> @@ -226,6 +226,29 @@ configuration option and requires that t
>  .RB (CAP_SYS_ADMIN ).
>  This flag can't be specified in conjunction with
>  .BR CLONE_THREAD .
> +
> +.BR "Signals handling:"
> +just like all the system calls that address a PID, signals can only be sent
> +to a process whose PID belongs to the same namespace as the caller.
> +
> +There are ways signals can be sent across namespaces boundaries such that

Just so I'm clear.  We're talking about the case here where, for
example, a process in a parent namespace sends a signal to a process
in the child namespace.  In such a case, the PID of the sender is not
meaningful.  Right?

> +the sender does not have a valid pid in the receiver's pid namespace.
> +In such cases, the sender pid will be seen by the receiver as a 0 value
> +(this has an impact, for example, on the
> +.BR siginfo_t
> +structure contents - NOTE, this is still under development).

Can you fill me in on the possibilities of "this is still under development"?

Cheers,

Michael

> +The "init" process of a PID namespace has a particular status, since it
> +is known both by its children as PID 1 and by its father's PID namespace
> +as any other PID. Thus, the "init" process of a PID namespace can be sent
> +any signal by a process that belongs to its ancestor's PID namespace (given
> +that the sender has the appropriate permission). But the only signals that
> +can be sent to the "init" process of a PID namespace from its own namespace
> +are those for which it has explicitly installed signal handlers.
> +More precisely, signals are sent successfully (i.e
> +.BR kill (2)
> +will not fail), but the "init" process will silently ignore unhandled signals.
> +
>  .TP
>  .BR CLONE_PARENT " (since Linux 2.3.12)"
>  If
>
> --
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
