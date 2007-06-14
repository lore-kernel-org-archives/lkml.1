Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbXFNMxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbXFNMxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXFNMwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:52:49 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:38079 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXFNMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:52:48 -0400
Date: Thu, 14 Jun 2007 14:52:06 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/loop* devices not appearing in /dev (at least since
 2.6.22-rc3*)
Message-ID: <20070614145206.58fdec91@localhost>
In-Reply-To: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 13:37:32 +0200
Matthew <jackdachef@gmail.com> wrote:

> now back to topic:
> 
> /dev/loop* seems to be broken since (at least) 2.6.22-rc3, since that
> was the first kernel I tried of the 2.6.22-rc* series
> 
> ls -l /dev/ | grep loop
> 
> shows no output

Yes, now the "loop" devices are dynamically allocated.... a patch to
provide the 8 "static allocated" loop devices is already in current git
(post -rc4, will be in -rc5).


commit a47653fc2643cf61bcabba8c9ff5c45517c089ba
Author: Ken Chen <kenchen@google.com>
Date:   Fri Jun 8 13:46:44 2007 -0700

    loop: preallocate eight loop devices

    The kernel on-demand loop device instantiation breaks several user space
    tools as the tools are not ready to cope with the "on-demand feature".  Fix
    it by instantiate default 8 loop devices and also reinstate max_loop module
    parameter.


-- 
	Paolo Ornati
	Linux 2.6.22-rc4-cfs-v16-g47932c49 on x86_64
