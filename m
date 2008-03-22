Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYCVMPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYCVMPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYCVMPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:15:42 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:33073 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbYCVMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:15:42 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2008 08:15:41 EDT
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Bernd Schubert <bernd-schubert@gmx.de>
Date: Sat, 22 Mar 2008 23:09:27 +1100
Message-ID: <47E4F6F7.40401@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: deadline unfairness
References: <200803221225.26728.bernd-schubert@gmx.de>
In-Reply-To: <200803221225.26728.bernd-schubert@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:
> Hello,
> 
> some it seems the deadline scheduler is rather unfair. Below is an example
> of md-raid6 initialization of md3, md4 and md5. All three md-devices
> do share the same blockdevices (we have patched md to allow
> parallel rebuild of shared block devices, since for us the cpu is the 
> bottleneck and not the block device).
> 
> All rebuilds started basically at the same time, as you can see, md3 is already
> done and now md4 rebuilds substantially faster than md5.
> [..]
> This is basically with a 2.6.22 kernel + lustre + md-backports, but nothing
> done to the scheduler.

Hi Bernd,

There is a deadline bug in pre-2.6.24 kernels where lower-sector requests can starve
higher-sector requests; you might be hitting this bug.  It was fixed by commit:
    6f5d8aa6382eef2b26032c88656270bdae7f0c42


 -- Aaron


