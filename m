Return-Path: <linux-kernel-owner+w=401wt.eu-S1030864AbXCHXIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864AbXCHXIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXCHXIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:08:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030864AbXCHXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OzsXH25CiVJZzq+2eGJsioRHoDAVfxIM5iA9kWwThr3kIvrYSwyexsSq5CuuFtFguYBSw5hfhXE1SgeblUYQSkrdMtgWLezj9IB7zsd5++memId253SN8iR/JdxQk9c3wFnW691420UQyS7kalH9y0iK6iTHE6c4FS2Mh8rNU5o=
Message-ID: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:08:17 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: sys_write() racy for multi-threaded append?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from sys_write():

        file = fget_light(fd, &fput_needed);
        if (file) {
                loff_t pos = file_pos_read(file);
                ret = vfs_write(file, buf, count, &pos);
                file_pos_write(file, pos);
                fput_light(file, fput_needed);
        }

Surely that's racy when two threads write to the same fd and the first
vfs_write call blocks or is preempted.  Or does fget_light take some
per-file lock that I'm not seeing?
