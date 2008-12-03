Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYLCMW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYLCMW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYLCMWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:22:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:50899 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYLCMWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:22:50 -0500
Message-ID: <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
Date: Wed, 3 Dec 2008 13:22:47 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Mark Jackson" <mpfj@mimc.co.uk>
Subject: Re: Badness at mm/backing-dev.c:179
Cc: linux-kernel@vger.kernel.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <49367691.5060007@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49367691.5060007@mimc.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 13:07, Mark Jackson <mpfj@mimc.co.uk> wrote:
> The following commit causes a "Badness at mm/backing-dev.c:179":-
>
> f1d0b063d993527754f062c589b73f125024d216 is first bad commit
> commit f1d0b063d993527754f062c589b73f125024d216
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Tue Dec 2 10:31:50 2008 -0800
>
>    bdi: register sysfs bdi device only once per queue

> Below is the extract from dmesg:-
>
> ------------[ cut here ]------------
> Badness at mm/backing-dev.c:179

That's a known issue, and will not cause any harm besides printing
this warning. Andrew added the warning to catch drivers who use one
single request queue for multiple devices. Currently known are mtd and
floppy (triggers only if you have more than one device per driver).
The drivers need to be changed to use a separate queue per device, to
get rid of this warning.

Thanks,
Kay
