Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXHCDeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXHCDeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXHCDeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:34:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:54897 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbXHCDeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C+a6SntI30pQxCzdJIAp4zxZ3uk2BSd7kIRJ9LQUSyhWV4TQ8TVnRTOrpqSu1VdyJI130G9k33Q6zM+r5h5kW3XEUK5ANSRGlNvcpEjc2zRmZ0i/mwo16WPC7IeWQVZvGUZhA1iw2AMT07OviGK3Wr35S4i9OBVTQQYJgGjUrS0=
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
	mode
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Zwane Mwaikambo <zwane@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
In-Reply-To: <46B293E0.2080008@gentoo.org>
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>
	 <20070630154230.4ad373fa.akpm@linux-foundation.org>
	 <4690E65B.5050607@gentoo.org>
	 <20070708111404.1486e73c.akpm@linux-foundation.org>
	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>
	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>
	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>
	 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>
	 <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>
	 <46AFDF3A.6080300@gentoo.org>  <1185933291.4688.11.camel@daplas>
	 <1186024158.4629.1.camel@daplas> <46B1547F.3090403@zytor.com>
	 <46B1AF0E.40703@gmail.com>  <46B293E0.2080008@gentoo.org>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 11:33:49 +0800
Message-Id: <1186112029.4844.9.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 22:33 -0400, Daniel Drake wrote:
> Antonino A. Daplas wrote:
> > How about this patch?
> > 
> > Tony
> > ---
> > 
> > Subject: video setup: Fix VBE DDC reading
> > 
> > Add memory operand constraint and write-only modifier to the inline
> > assembly to effect the writing of the EDID block to boot_params.edid_info.
> 
> 
> Thanks, this patch works in that Linux now reports the correct resolution.
> 
> However, the TV output is now scrambled...

The previous problem was just a display shift of 6 pixels, correct?  If
the display is now scrambled, then this is a new problem.

> I suspect this might be a result of adding CONFIG_FRAMEBUFFER_CONSOLE in 
> the most recent tests.

It's useless to unset CONFIG_FRAMEBUFFER_CONSOLE to 'n', he'll just end
up with a 640x400 stretched or windowed display.

Can he...

1. describe what 'scrambled' means?
2. Boot with video=intelfb:accel=0,<old options>?
3. post the output of 'fbset -i' and the latest dmesg?
4. change the color depth ('fbset -depth 16')?
5. If possible, run X using 'fbdev' as the driver at 16 bpp
   (I don't think 32 bpp works with X-fbdev)?

Tony




