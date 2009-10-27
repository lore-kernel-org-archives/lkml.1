Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZJ0Vcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZJ0Vcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932424AbZJ0Vct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:32:49 -0400
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:35019 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932406AbZJ0Vct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:32:49 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 17:32:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=j81yMj1llwf7l4GZwChnntSS5sqAtKz8zd8caZ0w9a1zcBMKhKT+I10fQ4A+y47qcr8GrH87A9lP0N2fe5djNu97o9H/cdwIvjQa9tj6IdAS2sWd7BeDtEhElVHuagzY;
Date: Tue, 27 Oct 2009 14:26:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
Message-ID: <20091027142609.73ac95e2@jbarnes-g45>
In-Reply-To: <4AE76463.6010404@gmail.com>
References: <4AE4BBBC.2070809@gmail.com>
	<20091026090548.2d4e20a9@jbarnes-g45>
	<4AE76463.6010404@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 22:21:39 +0100
Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:

> Jesse,
> 
> Jesse Barnes ha scritto:
> > On Sun, 25 Oct 2009 21:57:32 +0100
> > Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
> > 
> >> Hello,
> >>
> >> i lost video output, screen stays black, after suspend after
> >> commit c1c7af60892070e4b82ad63bbfb95ae745056de0 "drm/i915: force
> >> mode set at lid open time".
> >>
> >> I'm attaching my dmesg with 2.6.32-rc5 (actually
> >> 964fe080d94db82a3268443e9b9ece4c60246414), my bisect log and my
> >> config.
> >>
> >> git bisect response:
> >>
> >> c1c7af60892070e4b82ad63bbfb95ae745056de0 is the first bad commit
> >> commit c1c7af60892070e4b82ad63bbfb95ae745056de0
> >> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> >> Date:   Thu Sep 10 15:28:03 2009 -0700
> >>
> >>      drm/i915: force mode set at lid open time
> >>
> [snip]
> > 
> > I wonder if this is the real problem...  This patch introduced an
> > issue that was fixed by 06891e27a9b5dba5268bb80e41a283f51335afe7
> > that could cause a blank screen on lid open or resume, depending on
> > how lid events were delivered.  Should be easy enough to test
> > though, you can remove the whole
> > 
> > +       if (acpi_lid_open())
> > +               drm_helper_resume_force_mode(dev);
> > 
> > block and see if that also helps (in the current tree there's a lock
> > taken around the force_mode call, you'll need to remove those lines
> > too for testing).
> 
> So i've tried separately both this and the patch with the fix for 
> thinkpad (i have a samsung p460aa01 btw) with latest git and they
> have not fixed the issue.
> 
> +#if 0
>   	if (acpi_lid_open() && !dev_priv->suspended) {
>   		mutex_lock(&dev->mode_config.mutex);
>   		drm_helper_resume_force_mode(dev);
>   		mutex_unlock(&dev->mode_config.mutex);
>   	}
> +#endif

So just removing the above lines doesn't fix things, but reverting the
whole patch (c1c7af60892070e4b82ad63bbfb95ae745056de0) does?  If so the
only other thing I can think of is
2c907b72db4dd4e8af6dccb6e0ac122d78627b8d, which is in Linus's tree now,
but may not be in the drm-intel tree you're testing?

-- 
Jesse Barnes, Intel Open Source Technology Center
