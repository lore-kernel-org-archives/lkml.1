Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYC0OfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYC0OfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbYC0OfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:35:05 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44760 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbYC0OfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:35:04 -0400
Date: Thu, 27 Mar 2008 17:38:23 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Midhun A <midhunagni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Userspace - Kernel Space "Connector" test
Message-ID: <20080327143823.GA20443@2ka.mipt.ru>
References: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Mar 26, 2008 at 03:41:16PM +0530, Midhun A (midhunagni@gmail.com) wrote:
>    I want to use the Connector module (CONFIG_CONNECTOR) for Kernel
> space to User space communication.  My kernel version is 2.6.22.
> Before using it, I am trying out the example programs in the
> Documentation folder. I have cn_test.c built into the kernel (not
> loaded as a module) and I have compiled ucon.c.

You have to use smaller index than 32 or increase CN_NETLINK_USERS
parameter in include/linux/connector.h

Currently all kernel users fit that limitation, which is ok.

Also, parameter used in bind() is a bitmap of requested groups, to
listen on 0x123 idx you have to add it via setsockopt(), which is
commented in ucon.c.

So, either switch to smaller group number (connector index) or increase
above limit. If you will select the former case (it is simpler from
userspace point of view), you have to change bind() group, note that it
is a bitmap, os group N equals to (1<<N) bind() value. If you will
select the latter case and recompile connector module, then you have to
uncomment setsockopt() code in ucon.c

Both methods work, and you will get something like this:
$ sudo ./ucon
Thu Mar 27 17:29:19 2008 : [123.457] [00000002.00000000].
Thu Mar 27 17:29:20 2008 : [123.457] [00000003.00000000].
Thu Mar 27 17:29:21 2008 : [123.457] [00000004.00000000].
Thu Mar 27 17:29:22 2008 : [123.457] [00000005.00000000].
Thu Mar 27 17:29:23 2008 : [123.457] [00000006.00000000].

-- 
	Evgeniy Polyakov
