Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbYKWWqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYKWWqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYKWWq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:46:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61533 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:46:25 -0500
Date: Sun, 23 Nov 2008 16:47:08 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Kirill Korotaev <dev@openvz.org>, Herbert Poetzl <herbert@13thfloor.at>,
       Andrey Savochkin <saw@sw.ru>,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: CLONE_NEWUTS documentation
Message-ID: <20081123224708.GC12687@hallyn.com>
References: <492464F8.8070101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492464F8.8070101@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> Serge, Eric,
> 
> Below is a patch to document the CLONE_NEWUTS flag that was
> added in 2.6.19.

Thanks for writing this.

> Could you please review and let me know of improvements
> or inaccuracies?
> 
> By the way, does anyone know where the UTS name in the uname()
> API comes from? My best guess is that it's from Unix Timesharing
> System, but I don't know this for sure.

That sounds plausible - I've wondered myself and even googled a
bit, but not found an answer.  I suppose we might need to ask
Linus, or check one of the git repos that goes back to the early
90s and see who created the struct.

> Cheers,
> 
> Michael
> 
> diff --git a/man2/clone.2 b/man2/clone.2
> index 7212332..80f9caf 100644
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -341,6 +340,33 @@ configuration option and that the process be privileged
>  This flag can't be specified in conjunction with
>  .BR CLONE_THREAD .
>  .TP
> +.BR CLONE_NEWUTS " (since Linux 2.6.19)"
> +If
> +.B CLONE_NEWUTS
> +is set, then create the process in a new UTS namespace.

And the new UTS namespace will initially be identical as the
parent - same hostname and domainname.

> +If this flag is not set, then (as with
> +.BR fork (2)),
> +the process is created in the same UTS namespace as
> +the calling process.
> +This flag is intended for the implementation of control groups.

I'm not sure Eric was sufficiently clear - this flag is intended
for the implementation of virtual server functionality and maybe
checkpoint/restart (though I'm not sure any apps will care about
being able to reset the hostname on restart :)

It's not that you have to call it 'virtual server functionality',
just that 'control groups' is definately not right.

Maybe 'lightweight containers'?  "lightweight virtual servers'?

thanks,
-serge
