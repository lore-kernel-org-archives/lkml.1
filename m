Return-Path: <linux-kernel-owner+w=401wt.eu-S1763176AbXGRPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763176AbXGRPS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXGRPSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:18:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:35168 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbXGRPSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hVMjLV8gEokoJOgR+jUbnykN+dE09Rvj8pFKhSmBFDOcRYHtCBP1GnZNOLX/OKYQB8dneLjfZO8bIu9qY6MM0cDwifEsBc/QKjcW70veIMtf6OzqnUp+yiB01Lh7VUUIJxMLDJ3P1aeAvtDD1XjsXZuagZ1H2uOWhR5MU6c+2g8=
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: find mode with highest
	refresh rate in fb_find_mode()
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
In-Reply-To: <20070718143803.GA5787@localhost.localdomain>
References: <20070718084102.GA22694@spock.one.pl>
	 <20070718143803.GA5787@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 23:18:15 +0800
Message-Id: <1184771895.4523.33.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 16:38 +0200, Ondrej Zajicek wrote:
> On Wed, Jul 18, 2007 at 10:41:02AM +0200, Michal Januszewski wrote:
> > Currently if the refresh rate is not specified fb_find_mode() returns
> > the first known video mode with the requested resoluion, which provides
> > no guarantees wrt the refresh rate.  Change this so that the mode with
> > the highest refresh rate is returned instead.
> 
> What refresh rate it sets when used on card or monitor without DDC?

Yes, I noted this also while reviewing patches.  fb_find_mode() is used
predominantly with the 'generic' modedb which contains modes that are
not specific to the card or monitor.  And fb_try_mode() is not a
guarantee that the returned refresh rate will be safe (we have a lot of
drivers that do not check the timings against the display capabilities).

It would be best that fb_find_mode() return the safest refresh rate
(60Hz) instead of the highest.

Tony

