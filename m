Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbXEZF14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbXEZF14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXEZF1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:27:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36082 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXEZF1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:27:48 -0400
Message-ID: <4657C547.6030506@novell.com>
Date: Fri, 25 May 2007 22:27:35 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Andreas Gruenbacher <agruen@suse.de>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
References: <312681.33492.qm@web36609.mail.mud.yahoo.com>
In-Reply-To: <312681.33492.qm@web36609.mail.mud.yahoo.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- Andreas Gruenbacher <agruen@suse.de> wrote:
>   
>> AppArmor cannot assume anything about argv[0],
>>
>> and it would be a really bad idea to change the well-established semantics of
>>
>> argv[0].
>>
>> There is no actual need for looking at argv[0], though: AppArmor decides
>> based 
>> on the actual pathname of the executable...
>>     
> Right. My point was that if you wanted to use the gzip/gunzip
> example of a file with two names being treated differently based
> on the name accessed as an argument for AppArmor you could.
AppArmor detects the pathname of the file exec'd at the time the parent
exec's it, and not anything inside the child involving argv[0].

As such, AA can detect whether you did exec("gzip") or exec("gunzip")
and apply the policy relevant to the program. It could apply different
policies to each of them, so whether it has access to /tmp/mumble/barf
depends on whether you called it 'gzip' or 'gunzip'. Caveat: it makes no
sense to profile either gzip or gunzip in the AppArmor model, so I won't
defend what kind of policy you would put on them.

Finally, AA doesn't care what the contents of the executable are. We
assume that it is a copy of metasploit or something, and confine it to
access only the resources that the policy says.

>  If
> you don't want to, that's ok too. Jeremy raised a reasonable objection,
> and AppArmor could address it if y'all chose to do so. I seriously
> doubt that enforcing the argv[0] convention would break much, and I
> also expect that if it did there's a Consultant's Retirement to be
> made fixing the security hole it points out.
>   
AppArmor does address it, and I hope this explains how we detect which
of multiple hard links to a file you used to access the file without
mucking about with argv[0].

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
		   Security: It's not linear

