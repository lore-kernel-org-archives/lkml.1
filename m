Return-Path: <linux-kernel-owner+w=401wt.eu-S965924AbXCFPUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965924AbXCFPUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965925AbXCFPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:20:25 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3365 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965924AbXCFPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:20:24 -0500
Date: Tue, 6 Mar 2007 16:19:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: David Hubbard <david.c.hubbard@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070306161935.025a3ec1.khali@linux-fr.org>
In-Reply-To: <E1HODgC-0000h8-Vc@be1.lrz>
References: <7PvLN-1cj-3@gated-at.bofh.it>
	<7TEGV-6Jy-39@gated-at.bofh.it>
	<7TUBX-6TN-5@gated-at.bofh.it>
	<7UeqX-4QO-17@gated-at.bofh.it>
	<7UeqZ-4QO-27@gated-at.bofh.it>
	<7UgM5-np-1@gated-at.bofh.it>
	<7UgM8-np-11@gated-at.bofh.it>
	<7UnaS-2xP-9@gated-at.bofh.it>
	<7UnkC-2JB-9@gated-at.bofh.it>
	<7Uzcd-49u-3@gated-at.bofh.it>
	<7UEEN-4xi-3@gated-at.bofh.it>
	<E1HODgC-0000h8-Vc@be1.lrz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bodo,

On Mon, 05 Mar 2007 14:56:44 +0100, Bodo Eggert wrote:
> 1) Make a general resource allocation lock, if there is none.

Such a lock certainly exists, but I doubt it is public at the moment.

> 2) make ACPI take this lock whenever it touches ports not allocated by itself
>    and release it on function return.

This is costly.

> 3) Make ACPI callback the allocating device if it touches allocated ranges,
>    and on function return.

By callback, do you mean port forwarding as Rudolf Marek did, or more
simple "stop touching the device" and "you can touch the device again"
sort of signals? If the latter, this is no different from a mutex.

> 1 + 2 will replace allocating single ports and freeing them again (so ACPI won't
> prevent e.g. the display driver from loading just because it turned on the
> backlight) while preventing races with newly allocated ranges, and 3 allows
> coexistence with other drivers.

What benefit do you see compared to a lock taken by both AML and the
hardware monitoring drivers?

Care to submit a sample implementation?

Thanks,
-- 
Jean Delvare
