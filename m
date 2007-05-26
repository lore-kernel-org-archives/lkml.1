Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbXEZOFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbXEZOFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbXEZOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:05:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:42082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbXEZOFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:05:43 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 16:05:29 +0200
User-Agent: KMail/1.9.5
Cc: Crispin Cowan <crispin@novell.com>, casey@schaufler-ca.com,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <312681.33492.qm@web36609.mail.mud.yahoo.com> <4657C547.6030506@novell.com> <20070526143419.550bea93@the-village.bc.nu>
In-Reply-To: <20070526143419.550bea93@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261605.29829.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 15:34, Alan Cox wrote:
> > As such, AA can detect whether you did exec("gzip") or exec("gunzip")
> > and apply the policy relevant to the program. It could apply different
>
> That's not actually useful for programs which link the same binary to
> multiple names because if you don't consider argv[0] as well I can run
> /usr/bin/gzip passing argv[0] of "gunzip" and get one set of policies and
> the other set of behaviour.

I partially agree. Taken together with the policy of the calling process, 
things suddenly start to make more sense though (even if gzip/gunzip don't 
make good examples): if only allowed to execute /usr/bin/gzip, the calling 
process can still get the gunzip behavior, but it will be bound by 
the /usr/bin/gzip policy.

Controlling the policy is what we really care about; this limits the allowed 
behavior. We cannot really control the behavior of an application anyway 
(think of bugs alone), but we can set the bounds for that behavior.

> And then we have user added hardlinks of course.

Yes, allowing confined processes to change what they are allowed to execute 
under a more permissive policy is not such a good idea.

Thanks,
Andreas
