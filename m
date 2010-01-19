Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748Ab0ASORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0ASORN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130Ab0ASORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:17:12 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:56179 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0ASORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y7rDWpiuO0ukt1Fa/uiPwkXFvQHqkP6fYSg3jghr+loLWnUXnF/i0lrmhdt+41//B8
         KM/hychwtL5daZDhezBqdcKdbvM43R+3fdey25W2dVFJsVQLhWQTHSTPK+rxn6oH/7DP
         eFe7MuAarVCFf2+AjMR8CKTzHkzToeh9w6a8U=
Date: Tue, 19 Jan 2010 22:19:06 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: mojtaba <kernelppc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: module init data
Message-ID: <20100119141906.GA3473@hack>
References: <1dec3f771001180601jd511ab0g51aaaf8ed2195e9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dec3f771001180601jd511ab0g51aaaf8ed2195e9d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:01:56PM +0100, mojtaba wrote:
>Hi there,
>
>I have a kernel modules which needs to maintain a table of some
>information. the data in the table can be changed during the system
>run and some new raws might be added to the  table. The table also
>must be initialized at the system startup with the values from the
>previous run.
>
>As using files is not good in kernel mode, how can I load the data at
>the startup and store them as they changed? These information are
>device related. Can I use sysfs for this issue? Is there any tutorial
>on how to do that?
>

You can't use sysfs here, since it also stays in memory.

What you want is an interface to read and write those information
to/from the userspace, you can take iptables-save and iptables-restore
as an example.

One design of such interface would be passing a data structure which
contains all the table information from user space to kernel space
via syscall. Thus a user-space program will need to parse the data in
a file into that data structure and then do that syscall.

With this interface on hand, you can write an init-script to load the
table info during boot and to save the info during shutdown.

-- 
Live like a child, think like the god.
 
