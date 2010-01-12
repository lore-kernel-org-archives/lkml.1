Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274Ab0ALFaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab0ALFaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943Ab0ALFaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:30:20 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:65360 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0ALFaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:30:19 -0500
MIME-Version: 1.0
In-Reply-To: <1263271018.23507.8.camel@barrios-desktop>
References: <1263271018.23507.8.camel@barrios-desktop>
Date: Tue, 12 Jan 2010 11:00:18 +0530
Message-ID: <d760cf2d1001112130p8489b93uccd6a4650ff4a4a8@mail.gmail.com>
Subject: Re: [PATCH] Fix reset of ramzswap
From: Nitin Gupta <ngupta@vflare.org>
To: "minchan.kim" <minchan.kim@gmail.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 10:06 AM, minchan.kim <minchan.kim@gmail.com> wrote:
> ioctl(cmd=reset)
>        -> bd_holder check (if whoever hold bdev, return -EBUSY)
>        -> ramzswap_ioctl_reset_device
>                -> reset_device
>                        -> bd_release
>
> bd_release is called by reset_device.
> but ramzswap_ioctl always checks bd_holder before
> reset_device. it means reset ioctl always fails.

Are you sure you checked this patch?

This check makes sure that you cannot reset an active swap device.
When device in swapoff'ed the ioctl works as expected.

Greg: Can you please exclude earlier 'Free memory when create_device
is failed' patch?
That patch is correct however, my pending patch series conflicts with
that. So, I will
instead include that fix with this patch series (and add appropriate
signed-off-by)

Thanks,
Nitin
