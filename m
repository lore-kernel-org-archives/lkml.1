Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYKDBEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYKDBEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYKDBEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:04:33 -0500
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:41904 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752304AbYKDBEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:04:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=an+wdbh6pTo7qxjUERpqzQKaS5HoAsv7kTy+voXamq6lAFVt0DvXzCIQHzrh6IwbyG/wpen4sjqCSBX3XVWfSnjfF6MHIgoctfKbFA//g3kb4Vr57RsT6wXUcpX29rak;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.28-rc3(-next20081103) suspend issues on Lenovo X200
Date: Mon, 3 Nov 2008 17:04:25 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081103153945.GA20618@denkbrett.schottelius.org> <200811040155.59933.rjw@sisk.pl>
In-Reply-To: <200811040155.59933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031704.25717.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 3, 2008 4:55 pm Rafael J. Wysocki wrote:
> On Monday, 3 of November 2008, Nico -telmich- Schottelius wrote:
> > Updating my last post, system now runs with
> > the new Debian xserver-xorg-intel package:
> >
> > 2.6.28-rc3 and 2.6.28-rc3-next-20081103: acpi_sleep=s3_bios
> >    - suspend on console works
> >    - wakeup on console works
> >    - xorg (intel 2.3.2-2+lenny5) works
> >    - suspend on xorg works
> >    - wakeup on xorg is BROKEN:
> >       - console (kernel messages) is seen for a few seconds
> >       - kernel switches back to X
> >       - screen is partly drawn: X cursor is shown, background, no windows
> >       - system hard reboots after about 20 seconds (watchdog?)
> >
> > The Debian packages includes the lates G45 bugfix:
> >
> > http://packages.debian.org/changelogs/pool/main/x/xserver-xorg-video-inte
> >l/xserver-xorg-video-intel_2.3.2-2+lenny5/changelog
> >
> > So I'm waiting for your input on where to update what next ;-)
>
> Jesse, any ideas?  Can that be related to the DRM problem with radeon?

On many machines, we've found that re-POSTing the video device is incompatible 
with the i915 driver's suspend/resume functionality.  So things like s3_bios 
and vbetool shouldn't be used if the i915 driver works by itself.

-- 
Jesse Barnes, Intel Open Source Technology Center

