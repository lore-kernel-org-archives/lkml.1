Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYDDHBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYDDHBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYDDHBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:01:34 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:33384 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYDDHBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b6vQRyIiEVPFBG+WvtxNgM/Ll++vWAbp5yroazRvg/x4AW29SiXxuftOseUZN7QWXOlY+2pvSl14HLmxWt5qIhja0yedvhgFah1MjN6mS38Z/FN6GddxmQfoJgmQrruhNjG/xGf9qi1aGLjcW8R55VC80b0K9MNYfWxxtKfx/pU=
Message-ID: <e1d5030b0804040001t2a2b2fd3j75c656ec2318a932@mail.gmail.com>
Date: Fri, 4 Apr 2008 12:31:33 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Userspace - Kernel Space "Connector" test
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080327143823.GA20443@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
	 <20080327143823.GA20443@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

  Thanks a lot. I have changed the idx value to 7 and it worked. :)

Thanks,
Midhun

On Thu, Mar 27, 2008 at 8:08 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
>
>  On Wed, Mar 26, 2008 at 03:41:16PM +0530, Midhun A (midhunagni@gmail.com) wrote:
>  >    I want to use the Connector module (CONFIG_CONNECTOR) for Kernel
>  > space to User space communication.  My kernel version is 2.6.22.
>  > Before using it, I am trying out the example programs in the
>  > Documentation folder. I have cn_test.c built into the kernel (not
>  > loaded as a module) and I have compiled ucon.c.
>
>  You have to use smaller index than 32 or increase CN_NETLINK_USERS
>  parameter in include/linux/connector.h
>
>  Currently all kernel users fit that limitation, which is ok.
>
>  Also, parameter used in bind() is a bitmap of requested groups, to
>  listen on 0x123 idx you have to add it via setsockopt(), which is
>  commented in ucon.c.
>
>  So, either switch to smaller group number (connector index) or increase
>  above limit. If you will select the former case (it is simpler from
>  userspace point of view), you have to change bind() group, note that it
>  is a bitmap, os group N equals to (1<<N) bind() value. If you will
>  select the latter case and recompile connector module, then you have to
>  uncomment setsockopt() code in ucon.c
>
>  Both methods work, and you will get something like this:
>  $ sudo ./ucon
>  Thu Mar 27 17:29:19 2008 : [123.457] [00000002.00000000].
>  Thu Mar 27 17:29:20 2008 : [123.457] [00000003.00000000].
>  Thu Mar 27 17:29:21 2008 : [123.457] [00000004.00000000].
>  Thu Mar 27 17:29:22 2008 : [123.457] [00000005.00000000].
>  Thu Mar 27 17:29:23 2008 : [123.457] [00000006.00000000].
>
>  --
>         Evgeniy Polyakov
>
