Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYB0JyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYB0JyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 04:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYB0Jx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 04:53:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYB0Jx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:53:57 -0500
Date: Wed, 27 Feb 2008 06:52:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Robert Fitzsimons <robfitz@273k.net>
Cc: Bongani Hlope <bonganilinux@mweb.co.za>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of
 struct bttv_fh.
Message-ID: <20080227065251.3b2e4516@areia>
In-Reply-To: <20080227014729.GC2685@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
	<20080219111640.409870a9@gaivota>
	<20080226154102.GD30463@localhost>
	<20080227014238.GA2685@localhost>
	<20080227014729.GC2685@localhost>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 01:47:29 +0000
Robert Fitzsimons <robfitz@273k.net> wrote:

> A number of the radio tuner ioctl functions are shared with the TV
> tuner, these functions require a struct bttv_fh data structure to be
> allocated and initialized.
> 
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> 
> Mauro, the radio_open function may want to do more initialisation then
> the amount I copied from bttv_open.

Maybe, but the proper way would be to use just one open for both radio and
video, like cx88. This driver violates V4L2 API, since the spec says that
opening /dev/radio will select radio, by default, but it is possible to listen
video also on that interface (the opposite is valid also for /dev/video).

I'll apply the fixes, for now. The better would be if you could try to use the
same approach present on cx88.

Cheers,
Mauro
