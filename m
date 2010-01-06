Return-Path: <linux-kernel-owner+w=401wt.eu-S932566Ab0AFSZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0AFSZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510Ab0AFSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:25:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:33320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab0AFSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:25:44 -0500
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images 
 displayed are side by side (should only show one).
From: Peter Zijlstra <peterz@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
In-Reply-To: <a44ae5cd1001061010u2d31f24fx2dca6e7953687db@mail.gmail.com>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
	 <1262801263.4049.53.camel@laptop>
	 <a44ae5cd1001061010u2d31f24fx2dca6e7953687db@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 19:25:22 +0100
Message-ID: <1262802322.4049.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 13:10 -0500, Miles Lane wrote:
> On Wed, Jan 6, 2010 at 1:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-01-06 at 12:16 -0500, Miles Lane wrote:
> >> For a long time I have gotten two pictures of Tux showing up when I
> >> include the Tux display option in my custom kernel builds.
> >
> > Doesn't it show one for each cpu in the system?
> 
> Apparently so.  And, why this should be true is beyond me.

drivers/video/fbmem.c:

int fb_show_logo(struct fb_info *info, int rotate)
{
        int y;

        y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
                              num_online_cpus());
        y = fb_show_extra_logos(info, y, rotate);

        return y;
}


I guess its just a cute way of showing off how many cpus you've got ;-)

