Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZIVTaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZIVTaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZIVTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:30:11 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:1982 "EHLO
	mvpexchange120.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752AbZIVTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:30:11 -0400
User-Agent: Microsoft-Entourage/12.0.0.071130
Date: Tue, 22 Sep 2009 12:30:14 -0700
Subject: Re: (un)mount ramfs from C code
From: Brian McGrew <brian@visionpro.com>
To: Luciano Rocha <luciano@eurotux.com>
CC: <linux-kernel@vger.kernel.org>
Message-ID: <C6DE73D6.12872%brian@visionpro.com>
Thread-Topic: (un)mount ramfs from C code
Thread-Index: Aco7uxuDuAlOCo+hIk+FSXlMRd5F4g==
In-Reply-To: <20090922162658.GB7973@bit.office.eurotux.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You mean without using system(3), right? System call is how your program
> interacts with the outside world.
> 
> The relevant system calls are:
>   - mount(2): mount("none", "/mnt", "ramfs", 0, NULL);
>   - umount(2): umount("/mnt");
> 

Thanks for the help!  I'm getting there.  Considering the following:

If (mount("ramfs", rd_path, "ramfs", MS_NOEXEC | MS_NOSUID, "size=2000m") <
0) {
    strerror(errno);
} else {
    std::cout << "mounted";
}

Works great!  Thank you.  However, even though the filesystem is mounted and
/bin/mountpoint confirms it's a mountpoint, I do not see the mountpoint
listed in /etc/mtab.

Also, according to what I've read about ramfs, the size is supposed to be
limited to size=, however, I can cat /dev/zero until the box it out of
memory (and swap).

I think I'm just missing something and google's not helping a whole lot
since ramfs isn't the most popular subject today.

Thanks,

-b

