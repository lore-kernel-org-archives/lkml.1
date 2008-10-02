Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYJBSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYJBSgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJBSgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:36:33 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:49576 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJBSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:36:32 -0400
Date: Fri, 3 Oct 2008 00:06:13 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David.Madore@ens.fr
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20081002183613.GC29613@skywalker>
References: <20080930202728.GA6358@goelette.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930202728.GA6358@goelette.ens.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 10:27:29PM +0200, Quentin Godfroy wrote:
> Hi lists,
> 
> I'd like to report the following problem : after ~ 10 days' uptime on a
> Debian 2.6.26-1-686 kernel, my system becomes extremely sluggish and
> unresponsive and the OOM-killer starts targeting even innocent processes like
> identd or rsync (when the swap is disabled). The machine is low on RAM (192
> MB) but this has never been a problem before. As for the slowness, strace
> shows that the brk() syscall takes ages to complete; the blocking processes
> are in the D state (and for some reason the kernel gives no wchan info).
> 
> Free reports a large and constantly growing 'buffers' figure (more than
> 50% of the available memory). No userland processes seems to be consuming
> lare amounts of memory (sum of RSS in 'ps aux' is about 30 megs), and the
> overall system is mostly idle.
> 

We actually fixed one in 6be2ded1d7c51b39144b9f07d2c839e1bd8707f1.
It is not really a memory leak. But yes it was not releasing some
the prealloc space memory.

-aneesh
