Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZHFVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZHFVbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZHFVbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:31:31 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:40926 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756232AbZHFVba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:31:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zu4PeOpLunNm68XMct47Fq0jz5kfh6wZK7VZkA0TV/cEZq33ZgeuRTx0sNPUrHApApqGkx7hePvXhNYdBP35P7Ha2r7NK9FcGVciiyq2Z6AzyP0mbh18VlvESwyIZ+b2;
Date: Thu, 6 Aug 2009 14:31:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frans Pop <elendil@planet.nl>
Cc: Paul Rolland <rol@as2917.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire
 vblank..."
Message-ID: <20090806143128.2c5b76fe@jbarnes-g45>
In-Reply-To: <200907301306.51496.elendil@planet.nl>
References: <20090728091622.50e9933b@tux.DEF.witbe.net>
	<200907281244.13467.elendil@planet.nl>
	<20090728145359.252ff759@tux.DEF.witbe.net>
	<20090728092319.52ea57f1@jbarnes-g45>
	<20090728092319.52ea57f1@jbarnes-g45>
	<20090729085402.3bb7e3d9@tux.DEF.witbe.net>
	<200907301306.51496.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 13:06:50 +0200
Frans Pop <elendil@planet.nl> wrote:

> Paul Rolland wrote:
> > Some applications/hardware combinations are triggering the message
> > "failed to acquire vblank counter" to be issued up to 20 times a
> > second, which makes it both useless and dangerous, as this may hide
> > other important messages. This changes makes it only appear when
> > people are debugging. 
> > 
> > Signed-off-by: Paul Rolland <rol@as2917.net>
> > Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > --- linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c.orig     2009-07-26
> > 21:36:20.000000000 +0200 +++
> > linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c  2009-07-26
> > 21:36:34.000000000 +0200 @@ -566,7 +566,7 @@ int
> > drm_wait_vblank(struct drm_device *d
> > 
> > ret = drm_vblank_get(dev, crtc);
> > 	if (ret) {
> > -		DRM_ERROR("failed to acquire vblank counter,
> > %d\n", ret);
> > +		DRM_DEBUG("failed to acquire vblank counter,
> > %d\n", ret); return ret;
> > 	}
> > 	seq = drm_vblank_count(dev, crtc);
> 
> Actually, I just see that I get a different, but related error on
> suspend and when opening/closing a second X session:
>    *ERROR* trying to get vblank count for disabled pipe 0/1
> 
> Would it make sense to add the following to this patch:

Yes, that would be a good second patch (I also sent this one a few
times but it keeps getting lost).  If you want to send it to Linus more
formally, you can add my reviewed-by.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
