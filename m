Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXL2I3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXL2I3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXL2I3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:29:46 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39914 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXL2I3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:29:45 -0500
Message-ID: <47760578.2090305@davidnewall.com>
Date: Sat, 29 Dec 2007 18:59:44 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Mark Lord <lkml@rtr.ca>, Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> On Wed, 19 Dec 2007, David Newall wrote:
>   
>> Mark Lord wrote:
>>     
>>> But.. pity there's no mount flag override for smaller systems,
>>> where bind mounts might be more useful with link(2) actually working.
>>>       
>> I don't see it.  You always can make hard link on the underlying filesystem.
>> If you need to make it on the bound mount, that is, if you can't locate the
>> underlying filesystem to make the hard link, you can use a symbolic link.
>>     
>
> i run into it on a system where /home is a bind mount of /var/home ... i 
> did this because:
>
> - i prefer /home to be nosuid,nodev (multi-user system)
>   

Whatever security /home has, /var/home is the one that restricts because 
users can still access their files that way.

> - i prefer /home to not be on same fs as /
> - the system has only one raid1 array, and i can't stand having two 
>   writable filesystems competing on the same set of spindles (i like to
>   imagine that one fs competing for the spindles can potentially result
>   in better seek patterns)
> ...
> - i didn't want to try to balance disk space between /var and /home
> - i didn't want to use a volume mgr just to handle disk space balance...
>   

Pffuff.  That's what volume managers are for!  You do have (at least) 
two independent spindles in your RAID1 array, which give you less need 
to worry about head-stack contention.  You probably want different mount 
restrictions on /home than /var, so you really must use separate 
filesystems.  LVM is your friend.

But with regards to bind mounts and hard links:  If you want to be able 
to hard-link /home/me/log to /var/tmp/my-log, then I see nothing to 
prevent hard-linking /var/home/me/log to /var/tmp/my-log.

I think it's possible to be too precious about preserving the illusion 
of one file-system structure when the reality is something different.  
Don't lose site of reality.
