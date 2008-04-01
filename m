Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYDAQEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYDAQEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYDAQEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:04:35 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:45892 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYDAQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:04:33 -0400
X-Greylist: delayed 1946 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 12:04:33 EDT
Message-ID: <47F254F2.2000806@uni-koeln.de>
Date: Tue, 01 Apr 2008 17:29:54 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 06/45] KEYS: Make the keyring quotas controllable through
 /proc/sys [ver #35]
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk> <20080328143041.3483.46359.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143041.3483.46359.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells schrieb:
> Make the keyring quotas controllable through /proc/sys files:
> 
>  (*) /proc/sys/kernel/keys/root_maxkeys
>      /proc/sys/kernel/keys/root_maxbytes
> 
>      Maximum number of keys that root may have and the maximum total number of
>      bytes of data that root may have stored in those keys.
> 
>  (*) /proc/sys/kernel/keys/maxkeys
>      /proc/sys/kernel/keys/maxbytes
> 
>      Maximum number of keys that each non-root user may have and the maximum
>      total number of bytes of data that each of those users may have stored in
>      their keys.
> 
> Also increase the quotas as a number of people have been complaining that it's
> not big enough.  I'm not sure that it's big enough now either, but on the
> other hand, it can now be set in /etc/sysctl.conf.
> 

Hello David,

you're our hero! ;-)

We just hit this wall while migrating from RHEl 3 to RHEL 5 with some of 
our webservers.

[root@lvr11 ~]# cat /proc/key-users
     0:    99 98/98 96/100 1681/10000
    32:     2 2/2 2/100 56/10000
    38:     2 2/2 2/100 56/10000
    43:     2 2/2 2/100 56/10000
    51:     2 2/2 2/100 56/10000
    68:     2 2/2 2/100 56/10000
    81:     2 2/2 2/100 56/10000
    99:     2 2/2 2/100 56/10000
   348:     2 2/2 2/100 58/10000
42216:     2 2/2 2/100 62/10000
55188:     3 3/3 3/100 72/10000
56537:     2 2/2 2/100 62/10000
63743:     2 2/2 2/100 62/10000
68054:     2 2/2 2/100 62/10000

....


We're using OpenAFS on our systems and most of our webpages are stored 
in AFS. We have a lot of small projects for which a separate server 
would be a waste of 'metal'. Even in a virtual environment. So we're 
hosting a lot of apache instances on a single machine. Beause suexec 
doesn't work in an AFS environment, each instance is started by root 
with its own IP (to be able to talk HTTPS) and in a PAG with a separate 
token for a service user (to isolate the projects). Although each apache 
switches  over to the service user, the initial tokens are acquired by root.

On RHEL 3 with the old 2.4 kernel this was never a problem. But now...

Btw.: We have some machines with about hundred (!) different projects 
which need tokens.


Best regards,

Berthold Cogel

-- 
Dr. Berthold Cogel                             University of Cologne
E-Mail: cogel@uni-koeln.de                     ZAIK-US (RRZK)
Tel.:   +49(0)221/470-7873                     Robert-Koch-Str. 10
FAX:    +49(0)221/478-85845                    D-50931 Cologne - Germany
