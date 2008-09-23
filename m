Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYIWQtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYIWQtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYIWQqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:46:16 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55683 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754494AbYIWQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:46:13 -0400
Date: Tue, 23 Sep 2008 17:46:10 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: get_user_pages fails for contiguous memory?
Message-ID: <20080923164610.GI1916@fluff.org.uk>
References: <19F8576C6E063C45BE387C64729E739403CD7C968B@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739403CD7C968B@dbde02.ent.ti.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 09:19:51PM +0530, Hiremath, Vaibhav wrote:
> Hi,
> 
> For some reason (unknown to me) the VM_IO and VM_PFNMAP vm_flags are set when I use get_user_pages function, causing it to fail for me. I'm currently using 2.6.22 on an ARM platform.
> 
> My Actual test case is something -
> 
> I trying run/test a simple use case where, I am allocating buffers in one driver using get_free_pages, map them to user application and pass it to another driver for processing. 
> 
> I am allocating huge memory in frame buffer driver using get_free_pages at the init time. I would like to use this buffer in resizer driver (scatter gather DMA), which resizes the image depending on user configuration. 
> 
> If I allocate a memory using malloc or memalign from in user space and pass it to resizer driver it works fine.
> 
> Any suggestions/solution how to achieve this would really helpful to me.

Firstly, user a later kernel. How hard is upgrading?

Secondly, there is an DMA API for allocating DMA capable memory.

Thirdly, there's a limit of contiguous memory available, are you
sure that you can actually allocate that much memory in one go? Even
if you are, you probably can't guarantee to get it again if user processes
have caused memory map fragmentation.

And finally, wrong list! How hard is it to find the Linux ARM list?

PS, wrap your emails to 77 characters or less per line.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
