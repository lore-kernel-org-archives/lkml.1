Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXE0Dmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXE0Dmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 23:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXE0Dm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 23:42:29 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:2166 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbXE0Dm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 23:42:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQrAGyaWEZKhRO4UWdsb2JhbACBSoVhiEgBHA0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: =?utf-8?q?C=C3=A9dric_Augonnet?= <cedric.augonnet@gmail.com>
Subject: Re: input_polldev won't load as a module
Date: Sat, 26 May 2007 23:42:37 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <f56c1ba00705261425t1e6eb59as72ca5f6e3a3c4d0@mail.gmail.com>
In-Reply-To: <f56c1ba00705261425t1e6eb59as72ca5f6e3a3c4d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705262342.37768.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cédric,

On Saturday 26 May 2007 17:25, Cédric Augonnet wrote:
> Hi,
> 
> When trying to load input_polldev compiled as a module on my
> 2.6.22-rc2-mm1 kernel, it is impossible because of some symbols that
> are said to be missing :
> 
> gonnet@porcinet:~$ sudo modprobe input_polldev
> FATAL: Error inserting input_polldev
> (/lib/modules/2.6.22-rc2-mm1=porcinet/kernel/drivers/input/misc/input-polldev.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> gonnet@porcinet:~$ dmesg
> [  137.559553] input_polldev: Unknown symbol queue_delayed_work
> [  137.559621] input_polldev: Unknown symbol destroy_workqueue
> [  137.559652] input_polldev: Unknown symbol __create_workqueue
> 
> I enclosed my .config in case it may help.
> 
> On the other hand, if I choose CONFIG_INPUT_POLLDEV=y, it seems to
> work without any problem. Provided the Kconfig file, it looks like
> this could compiled either like that or as a module.
> 
> Unfortunately, given my very limited understanding i could really not
> figure out why these symbols cannot be resolved, so i'll be really
> interrested if anyone can propose a solution or an explanation.
> 

It is caused by nyssing GPL license for the module. Please try 2.6.22-rc3,
the issue should be fixed by commit 36bd52a49b790a71f3d353cdddf2f22e1e6f84ff.

-- 
Dmitry
