Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZKEDQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZKEDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZKEDQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:16:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43782 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZKEDQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fJNzx06p1pBN7DPziWwFmgh4YesqMh9fsHuplP9BMdDCbx3n4uUFuV9rMB0gUcYt7r
         6g+t2zKymsHUXu1z/Q4Cf/vlJkADbkAyOBgS8U9CSkrwscVig5zC2LQcXxe4jeHp/kOD
         vYd+3aLkh+0as333795ofq9ESaDbVpidVTkg0=
Subject: Re: Is this needed to enable turbo mode/boost on i7 processors?
From: Calvin Walton <calvin.walton@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0911031600130.6593@p34.internal.lan>
References: <alpine.DEB.2.00.0911031340110.12341@p34.internal.lan>
	 <alpine.DEB.2.00.0911031600130.6593@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 22:16:56 -0500
Message-ID: <1257391016.9724.11.camel@nayuki>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 16:00 -0500, Justin Piszcz wrote:
> I realize the BIOS is supposed to take care of it, but it would be nice if 
> there was an easy way to verify it is working.
> 
> On Tue, 3 Nov 2009, Justin Piszcz wrote:
> 
> > Hello,
> >
> > Per: http://kolbusa.livejournal.com/71066.html
> >
> > Is it necessary to do this--?
> >
> > Is there a way to verify whether turbo boost is being enabled when one core 
> > is at 100% cpu?
> >
> > Justin.

Assuming that the cpufreq functionality is enabled in your kernel, a
simple

 cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq

Should return the frequencies that each cpu core is currently running
at. I'm using a core i7 920 (2.67 ghz nominal) and have seen it hit 2.80
ghz on occasion.

None of the extra kernel options mentioned in that blog post should be
required, assuming that you are using an up-to-date kernel. I would
expect this to work correctly in the latest Ubuntu or Fedora, for
example.

For the record, I have all of the bios power saving modes enabled (and
turbo mode, of course), and am using the kernel 'ondemand' governor with
no extra userspace applications or configuration.

My understanding of how it works is that when the cpu load is OK, the
bios adjusts the values for the top couple of speedstep settings (use 

 cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_frequencies

to see them), and the kernel will automatically take advantage of them,
according to the cpufreq governor you select.

-- 
Calvin Walton <calvin.walton@gmail.com>

