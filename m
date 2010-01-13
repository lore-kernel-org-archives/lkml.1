Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353Ab0AMVHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0AMVHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648Ab0AMVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:07:23 -0500
Received: from www17.your-server.de ([213.133.104.17]:42838 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0AMVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:07:22 -0500
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes
 the screen flicker
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <20100112095702.4b22fcc1@jbarnes-piketon>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.GGD.GilSLB@chimera>
	 <1263228784.12830.0.camel@localhost.localdomain>
	 <20100111085527.104f5c3e@jbarnes-piketon>
	 <8B599161-2977-4A43-B88F-36E87AFCF4EA@m3y3r.de>
	 <20100111111941.189eb41e@jbarnes-piketon>
	 <1263318189.3284.2.camel@localhost.localdomain>
	 <20100112095702.4b22fcc1@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 22:06:34 +0100
Message-ID: <1263416794.17308.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 12.01.2010, 09:57 -0800 schrieb Jesse Barnes:

> Yeah, the function tracer should be able to do it (though I don't know
> how to use it offhand, maybe through the perf tool?).  Or you could
> just add some DRM_ERROR lines. :)

I set the function tracer to the function "drm_mode_getconnector":

here is the output, that i captured after I start playing a video with
totem (i.e. the flickering starts):

# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            Xorg-1443  [000]  1880.280581: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.394308: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.395379: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.406780: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.420169: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.424712: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.444334: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.631332: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.632368: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.643349: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.656874: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.662623: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.764168: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.986639: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.988920: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1880.999856: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.013260: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.024310: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.069299: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.303194: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.305308: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.316421: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.329808: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.337493: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.420231: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.633036: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.634075: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.646363: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.659741: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.670751: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.742476: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.959634: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.960669: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.972904: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.986272: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1881.993965: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.078704: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.295050: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.296104: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.309439: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.322834: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.333858: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.407520: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.622870: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.623896: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.635987: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.649366: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.660390: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.772479: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.992680: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1882.993707: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.005845: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.019238: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.026922: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.142571: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.359167: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.360190: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.372398: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.385862: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.393457: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.479378: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.692285: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.693326: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.705552: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.718920: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.729979: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1883.808964: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.032179: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.033222: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.045422: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.058808: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.066525: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.151051: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.368836: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.369872: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.382019: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.395401: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.403100: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.504375: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.725273: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.726373: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.738545: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.751942: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.759633: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1884.828803: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.045242: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.046283: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.058442: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.071842: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.079498: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.162244: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.388404: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.389429: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.401620: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.415130: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.421548: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.510004: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.685747: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.686776: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.698176: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.711599: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.723703: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1885.808301: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.032422: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.033456: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.044685: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.058081: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.065622: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.140785: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.367987: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.369012: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.381254: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.394621: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.402334: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.456423: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.671279: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.672302: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.684470: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.697844: drm_mode_getconnector <-drm_ioctl
            Xorg-1443  [000]  1886.705543: drm_mode_getconnector <-drm_ioctl

Any idea why the function "drm_mode_getconnector" is called so many
times?

The call chain seems to be

drm_ioctl ->
drm_mode_getconnector ->
drm_helper_probe_single_connector_modes ->
  intel_crt_detect, intel_hdmi_detect and intel_lvds_detect

> 
> > > The LVDS state will also be checked at ACPI LID event time, maybe
> > > your platforms is getting spurious LID events?
> > 
> > maybe! where can I check this? acpid log file?
> 
> Yeah or using acpi_listen I think.
> 

acpi lid events seems to correspond to the lid status.

greets
thomas


