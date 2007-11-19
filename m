Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXKSHjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXKSHjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXKSHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:39:05 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:38284 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXKSHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:39:04 -0500
Message-ID: <47413E19.8080309@abinetworks.biz>
Date: Mon, 19 Nov 2007 08:41:13 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: NFS Bug in 2.6.23 ? SOLUTION ?
References: <473D6B5C.4090701@abinetworks.biz>	 <20071116121148.GI4290@tatooine.rebelbase.local>	 <1195222863.7653.18.camel@heimdal.trondhjem.org>	 <473EEEC7.1070300@abinetworks.biz> <473F2464.3020905@abinetworks.biz>	 <474087F6.9030305@abinetworks.biz> <1195414941.10559.10.camel@heimdal.trondhjem.org>
In-Reply-To: <1195414941.10559.10.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:

>On Sun, 2007-11-18 at 19:44 +0100, Gianluca Alberici wrote:
>  
>
>>Trond,
>>
>>The problem is in nfs_mountpoint_timeout. After this time 
>>dentry_delete(/,4) removes the mountpoint, then it is very difficult to 
>>automount (at least with CFSD), one has got to try 2 or three times 
>>cd'ing into the mount point. Applications wont ever had the chance to 
>>autoremount (ENOTDIR).
>>    
>>
>
>Sounds like CFSD has a bug w.r.t. what fsid it returns to the client.
>
>  
>
Very likely...and im sure its not the one...unfortunately CFSD has not 
been mantained for a very long time (i think 2001)
but in the end up to 2.6.20 has done its job very well...

>>I have some questions:
>>
>>- nfs_mountpoint_timeout seems to be set in sysctl.c even if nfsv4 is 
>>not. Is this correct ? I've read somewhere that it was introduced for v4.
>>    
>>
>
>Wrong. It applies to all mountpoint crossing. If the server tells us
>that the fsid has changed, then we create a new mountpoint.
>
>  
>
>>- Why this sysctl is not registered in my 2.6.20 kernel where it should 
>>be registered ?
>>    
>>
>
>Prior to 2.6.21-rc5, we had a bug in register_nfs_fs() whereby it failed
>to register the sysctl table unless you enabled NFSv4.
>
>  
>
>>- Why this parameter has not a 'disabled' value (i mean kind of -1) ?
>>    
>>
>
>Why should it? 
>
For backwards compatilbility ? Couldn't be useful to have the chance to 
make NFS client act
exactly as it always did, at least as an option, to talk to 'ancient NFS 
servers' ?

Or at least have the chance to set this timeout to infinity ?

Many thanks for your time, best regards,

Gianluca

>The current behaviour is quite correct. If you cross a
>mountpoint, then you should remount in order to ensure that the inode
>numbers remain unique per-filesystem.
>  
>
>We know that some ancient NFS servers had problems returning the correct
>fsid in readdirplus replies, so 2.6.22 adds support to disable
>readdirplus calls via a 'nordirplus' mount option. I guess you could try
>that...
>
>Trond
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>  
>

