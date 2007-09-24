Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXIXNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXIXNcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXIXNb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:31:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbXIXNb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:31:57 -0400
Message-ID: <46F7BC3D.2040408@redhat.com>
Date: Mon, 24 Sep 2007 09:31:41 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 14/22] NFS: Use local caching
References: <10249.1190416956@redhat.com> <46F3F8BF.1030404@redhat.com> <20070921144703.8323.50492.stgit@warthog.procyon.org.uk> <20070921144815.8323.77745.stgit@warthog.procyon.org.uk> <10304.1190417846@redhat.com>
In-Reply-To: <10304.1190417846@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>   
>> Peter Staubach <staubach@redhat.com> wrote:
>>
>>     
>>> Did I miss the section where the modified semantics about which
>>> mounted file systems can use the cache and which ones can not
>>> was implemented?
>>>       
>> Yes.
>>     
>
> fs/nfs/super.c:
>
> 		case Opt_sharecache:
> 			mnt->flags &= ~NFS_MOUNT_UNSHARED;
> 			break;
> 		case Opt_nosharecache:
> 			mnt->flags |= NFS_MOUNT_UNSHARED;
> 			mnt->options &= ~NFS_OPTION_FSCACHE;
> 			break;
> 		case Opt_fscache:
> 			/* sharing is mandatory with fscache */
> 			mnt->options |= NFS_OPTION_FSCACHE;
> 			mnt->flags &= ~NFS_MOUNT_UNSHARED;
> 			break;
> 		case Opt_nofscache:
> 			mnt->options &= ~NFS_OPTION_FSCACHE;
> 			break;
>
> Hmmm...  Actually, I'm not sure this is sufficient.

This doesn't seem to take into account any of the other options
which can cause sharing to be disabled.  Perhaps SteveD can add
his patch to the mix which does resolve the issues?

    Thanx...

       ps
