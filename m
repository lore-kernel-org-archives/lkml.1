Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbXIUI3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbXIUI3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXIUI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:29:31 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34104 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbXIUI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:29:31 -0400
Message-ID: <46F380E4.4040606@davidnewall.com>
Date: Fri, 21 Sep 2007 17:59:24 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com>
In-Reply-To: <46F2DDD0.3030500@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> there is no question that pivot_root is intended to have breadth for 
> more than one process. 

I think it's clear from the man page that the original idea was to be 
able to pivot_root for individual processes.  The reason it doesn't do 
that, the reason it affects all processes, is to work around the 
bootstrap problem, where processes that don't care what their root (or 
current) directory is are still using the original root.

An extra parameter could be added to specify which behavior is desired, 
probably defaulting to the current behavior. That would remove the need 
to use a chroot bug.
