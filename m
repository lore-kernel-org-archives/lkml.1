Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZEVPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZEVPVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZEVPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:21:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53419 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVPVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905221051350.3006-100000@iolanthe.rowland.org>
References: <20090522105313.63e309f0@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.0905221051350.3006-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 22 May 2009 17:21:17 +0200
Message-ID: <ac3eb2510905220821n629314c3tb113802f52abc67c@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 17:12, Alan Stern <stern@rowland.harvard.edu> wrote:
> Anyway, enumeration isn't the problem.  The real problem has two parts:
>
>        Automatic probing and binding of kernel drivers, including
>        selection and installation of a configuration (this really
>        _does_ mess up virtualization).
>
>        The fact that a window exists immediately after the
>        registration of a newly-detected device before a user
>        process can lock the device file.  During this window,
>        other processes could open the file.
>
> The second part can be solved (among cooperating processes) by use of
> port-lock files, with no kernel involvement.  The first part does
> require a kernel interface of some sort, but it wouldn't have to be
> complicated.  The mere fact that a port-lock file was open could be
> enough to prevent automatic configuration, probing, and binding.
>
> Does this seem like reasonable approach?

Would releasing the "lock" trigger a kernel-driver-binding call?

The lock will always lock all devices of a specific hub?

Thanks,
Kay
