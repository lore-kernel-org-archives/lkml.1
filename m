Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYCKRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYCKRz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYCKRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:55:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYCKRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:55:10 -0400
Date: Tue, 11 Mar 2008 10:36:46 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080311173646.GA26931@kroah.com>
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <47D657A3.5080801@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D657A3.5080801@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 12:57:55PM +0300, Pavel Emelyanov wrote:
> 
> Besides, I've measured some things - the lat_syscall test for open from 
> lmbench test suite and the nptl perf test. Here are the results:
> 
>         sec     nosec
> open    3.0980s  3.0709s
> nptl    2.7746s  2.7710s
> 
> So we have 0.88% loss in open and ~0.15% with nptl. I know, this is not that
> much, but it is noticeable. Besides, this is only two tests, digging deeper
> may reveal more.

I think that is in the noise of sampling if you run that test many more
times.

> Let alone the fact that simply turning the CONFIG_SECURITY to 'y' puts +8Kb 
> to the vmlinux...
> 
> I think, I finally agree with you and Al Viro, that the kobj mapper is 
> not the right place to put the filtering, but taking the above numbers 
> into account, can we put the "hooks" into the #else /* CONFIG_SECURITY */
> versions of security_inode_permission/security_file_permission/etc?

Ask the security module interface maintainers about this, not me :)

good luck,

greg k-h
