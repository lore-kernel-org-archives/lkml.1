Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbYBHR2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbYBHR2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYBHR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:28:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbYBHR2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:28:12 -0500
Date: Fri, 8 Feb 2008 12:26:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: why kexec insists on syncing with recent kernels?
Message-ID: <20080208172658.GB23772@redhat.com>
References: <47AB120A.1000600@wpkg.org> <20080207163752.GD11969@redhat.com> <47AB38E2.9050509@wpkg.org> <20080208160408.GB18782@redhat.com> <20080208090407.4ab240f1.randy.dunlap@oracle.com> <47AC8F34.3020705@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC8F34.3020705@wpkg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 06:19:48PM +0100, Tomasz Chmielewski wrote:
> Randy Dunlap schrieb:
>
> (...)
>
>>> Even if you did -f, it must have shutdown the network. I think somehow
>>> in latest kernels there is some dependency on network and that's why
>>> not shutting down network in this case is helping you.
>>
>> I'm seeing NFS mounts take forever to unmount (at shutdown/reboot).
>> (forever => 1 hour ... or never completes)
>>
>> Is this similar to the problem that the OP is asking about?
>
> Is it a diskless station?
>
> Even in not, just make sure you don't shut the network down before NFS is 
> actually unmounted...?

Network is shutdown just before kexec -e finally enters the kernel and 
starts preparing to jump to the new kernel. Any syncing operation, or
File system unmounting operation will be done before that.

Can't understand why not disabling the network will help in NFS umount
or syncing operation. It has to be something else.

Thanks
Vivek
