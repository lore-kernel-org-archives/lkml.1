Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXLHOIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXLHOIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 09:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXLHOHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 09:07:51 -0500
Received: from lilly.ping.de ([83.97.42.2]:1331 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750790AbXLHOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 09:07:49 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2007 09:07:49 EST
Date: Sat, 8 Dec 2007 14:50:20 +0100
From: Patrick Mau <mau@oscar.ping.de>
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: programs vanish with 2.6.22+
Message-ID: <20071208135020.GA2512@oscar.prima.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712072352.04454.M4rkusXXL@web.de> <Pine.LNX.4.64.0712080043360.847@axis700.grange> <200712081325.21790.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712081325.21790.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 01:25:21PM +0100, Markus wrote:
> Well, just tried it. Started a dozen konquerors and attached strace to 
> everyone. When one disapeared, I only got a "Process 9246 detached", 
> nothing else is printed or written in the log.
> 
> Markus

Hallo Markus

Whenever the connection to the X server is dropped the application
using that connection will be terminated by the client library
error handler (KDE/Qt/X11).

Probably the applications simply drop out of their event loop and
terminate, you should see some X11 related error messages in

.xsession-errors

My guess would be that some of the eye-candy in KDE is using
DRI / OpenGL features that might be the cause for mailfunction.

I would suggest you start by disabling DRI / AIGLX rendering
in your xorg.conf and see if your applications work without
all those nifty features.

Below you can find some settings to disable AIGLX, DRI and
composite rendering.

They should be integrated in the configuration sections I
quoted. This is not a complete configuration file.

Best regards,
Patrick

--- <snip> ---

Section "ServerFlags"
 Option "AIGLX" "false"
EndSection

Section "Module"
 Disable "dri"
EndSection

Section "Extensions"
 Option "Composite" "false"
EndSection

--- <snip> ---


