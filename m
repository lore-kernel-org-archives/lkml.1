Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbYASWYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbYASWYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYASWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:24:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27935 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYASWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:24:37 -0500
X-SBRS: None
X-MesageID: 38452084
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,222,1199682000"; 
   d="scan'208";a="38452084"
Message-ID: <47927877.5090209@citrix.com>
Date: Sat, 19 Jan 2008 14:23:51 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [updated PATCH] xen: fix section usage in xen-head.S and setup.c
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking> <20080119131743.GA26615@uranus.ravnborg.org> <20080119212019.GB29070@uranus.ravnborg.org>
In-Reply-To: <20080119212019.GB29070@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Failing to specify "ax" in the pushsection caused ld to generate
> an additional section for .init.text appending a number.
>   

Thanks for tracking this down.  I think the "ax" appeared and 
disappeared over time, but this looks like the proper solution.

Are you going to submit this, or do you want me to pick it up?

> A side effect of this was a section mismatch warning because modpost
> did not recognize a .init.text section named .init.text.1:
> WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
>
> Fix this by hardcoding the "ax" in the pushsection.
> Thanks to Torlaf for reporting this.
>
> Alan Modra provided the hint that made me able to
> locate the root cause of this warning.
> And Mike Frysinger told me how to properly fix it
> using __INIT/__FINIT.
>
> Fix following Section mismatch warning in addition:
> WARNING: vmlinux.o(.text+0x14c8): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')
>
> fiddle_vdso was only used from a __init function - so declare it __init.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
>   

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

Thanks,
    J
