Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZCVGrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZCVGrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 02:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZCVGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 02:47:12 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:45660 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZCVGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 02:47:11 -0400
Message-ID: <49C5DEE5.6090205@davidnewall.com>
Date: Sun, 22 Mar 2009 17:17:01 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: df -h shows ~10 times bigger size when umounting pendrive
References: <200903220150.16004.a.miskiewicz@gmail.com>
In-Reply-To: <200903220150.16004.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:
> While umount was running and data were synced on the
> pendrive df -h showed:
>
> [arekm@t400 ~]$ df -h
> System plik�w         rozm. u�yte dost. %u�. zamont. na
> /dev/sda3             9,6G  4,2G  5,5G  44% /
> /dev/sdb1             9,6G  4,2G  5,5G  44% /media/floppy
>   

This looks to me like a race between umount and df.  By the time df had
read mtab (to find the mounted filesystem), the pen drive had already
been unmounted; but umount hadn't yet updated mtab.  It's a pretty
trivial sort of fault, and not worth worrying about.
