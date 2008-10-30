Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYJ3IbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYJ3IbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYJ3Ia7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:30:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:10840 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYJ3Ia6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:30:58 -0400
Message-ID: <ac3eb2510810300130k29d6533ei6f49948889158712@mail.gmail.com>
Date: Thu, 30 Oct 2008 09:30:56 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: why does udev set timeout for all SCSI devices?
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <49092208.9060909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49092208.9060909@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:55, Tejun Heo <tj@kernel.org> wrote:
> As the $SUBJ says, why does udev set timeout for all SCSI devices?
> It's the following two rules.
>
> 50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
> ACTION=="add", ATTR{type}=="0|7|14", ATTR{timeout}="60"
> 50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
> ACTION=="add", ATTR{type}=="1", ATTR{timeout}="900"
>
> The appropriate default timeout differs depending on the transport and
> the type of the attached device, so the above two rules harm more than
> help.  The affect of the above two rules weren't visible for some
> reason but with recent block layer timeout update, they actually work
> and cause problems.

It's in there for years, I can not even dig out, where it is coming
from. I just removed it from the default rules.

Thanks,
Kay
