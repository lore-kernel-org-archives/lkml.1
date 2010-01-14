Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467Ab0ANKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0ANKQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559Ab0ANKQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:16:40 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:58121 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750837Ab0ANKQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:16:39 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 05:16:39 EST
Subject: Re: drm/radeon/kms: fix up LVDS handling on macs (v2)
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
In-Reply-To: <1263437142.724.320.camel@pasglop>
References: <201001140059.o0E0x4wS006650@hera.kernel.org>
	 <1263437142.724.320.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jan 2010 11:09:41 +0100
Message-ID: <1263463781.3544.4714.camel@thor>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 13:45 +1100, Benjamin Herrenschmidt wrote: 
> On Thu, 2010-01-14 at 00:59 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/3890ddf56dbc0f804953198e65a7e406ed654576
> > Commit:     3890ddf56dbc0f804953198e65a7e406ed654576
> > Parent:     804c7559e9376c3ba78ae15a30337b1e24f8ae80
> > Author:     Alex Deucher <alexdeucher@gmail.com>
> > AuthorDate: Tue Jan 12 11:16:57 2010 -0500
> > Committer:  Dave Airlie <airlied@redhat.com>
> > CommitDate: Wed Jan 13 13:25:08 2010 +1000
> > 
> >     drm/radeon/kms: fix up LVDS handling on macs (v2)
> >     
> >     Based on radeonfb code and recent ddx fix.
> >     
> >     v2: minor formatting fix from Michel Dänzer
> >     
> >     Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> >     Reviewed-by: Michel Dänzer <michel@daenzer.net>
> >     Tested-by: Michel Dänzer <michel@daenzer.net>
> >     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> I have to dbl check that ... but I think the "Real" issue is that some
> panel have inverted polarity on the PWM signal. Thus if BLON is turned
> off the panels goes full backlight instead among other things :-)
> 
> However, not all macs are the same. If you look at the radeonfb code,
> we do things differently depending on the mac model...

I have looked at radeonfb for a patch I posted a while ago to expose a
backlight class device with KMS, and I can only see what you describe
above affecting the LVDS_GEN_CNTL backlight level, not BLON or
BL_MOD_EN. Am I missing something?

Without my patch, KMS doesn't change the backlight level at all, so
assuming the firmware manages to enable the backlight, it should stay
like that.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
