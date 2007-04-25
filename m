Return-Path: <linux-kernel-owner+w=401wt.eu-S2992909AbXDYSoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992909AbXDYSoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992907AbXDYSoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:44:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49865 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992897AbXDYSoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:44:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, linux-security-module@vger.kernel.org
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
	<E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
	<462F87EA.1000002@zytor.com>
	<20070425172012.GA20336@sergelap.austin.ibm.com>
	<m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com>
	<20070425175609.GB20165@vino.hallyn.com>
Date: Wed, 25 Apr 2007 12:41:41 -0600
In-Reply-To: <20070425175609.GB20165@vino.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 25 Apr 2007 12:56:09 -0500")
Message-ID: <m1647ks3dm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> Are there other permission checks that mount is doing that we
>> care about.
>
> Not mount itself, but in looking up /share/fa/root/home/fa,
> user fa doesn't have the rights to read /share, and by setting
> fsuid to fa and dropping CAP_DAC_READ_SEARCH the mount action fails.

Got it. 

I'm not certain this is actually a problem it may be a feature.
But it does fly in the face of the general principle of just
getting out of roots way so things can get done.

I think we can solve your basic problem by simply doing like:
chdir(/share); mount(.);  To simply avoid the permission problem.

The practical question is how much do we care.

> But the solution you outlined in your previous post would work around
> this perfectly.

If we are not using usual permissions which user do we use current->uid?
Or do we pass that user someplace?

>> > If it were really the equivalent then I could keep my capabilities :)
>> > after changing it.
>> 
>> We drop all capabilities after we change the euid.
>
> Not if we've done prctl(PR_SET_KEEPCAPS, 1)

Ah cap_clear doesn't do the obvious thing.

Eric
