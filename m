Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513Ab0AKSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0AKSGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224Ab0AKSGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:06:50 -0500
Received: from www17.your-server.de ([213.133.104.17]:58904 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0AKSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:06:49 -0500
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes
 the screen flicker
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <20100111085527.104f5c3e@jbarnes-piketon>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.GGD.GilSLB@chimera>
	 <1263228784.12830.0.camel@localhost.localdomain>
	 <20100111085527.104f5c3e@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 19:05:58 +0100
Message-ID: <1263233158.2161.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 11.01.2010, 08:55 -0800 schrieb Jesse Barnes: 
> On Mon, 11 Jan 2010 17:53:04 +0100
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > Am Sonntag, den 10.01.2010, 23:56 +0100 schrieb Rafael J. Wysocki:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.31 and 2.6.32.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > > should be listed and let me know (either way).
> > > 
> > 
> > Yes, still should be listed.
> > 
> > Problem still exists in 2.6.32.3 and 2.6.33-rc3-00097-g2c1f189, that
> > contains
> > this commit:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cda9d05c499093c67b4a376a15009923acc2127a
> > 
> > The above commit removes the render reclock support, that ought to
> > fix a common kind of problem encountered on i915 hardware, but not on
> > my machine.
> > 
> > Still need to boot with "nomodeset" to have a workable system.
> 
> Does this patch prevent the flicker?

No, sorry.

Reverting b42d4c5c6a872815d711e5d51a600f5122c38eee (i.e. the commit I
bisect my problem to) on top of 3c8ad49b015eb115fbd6982f56d530f53cf57f84
(i.e. 2.6.33-rc3-00147-g3c8ad49) make the problem go away.

My changes are:

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index f4b4aa2..15c6e6b 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -629,6 +629,8 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
 {
        enum drm_connector_status status = connector_status_connected;
 
+       return status;
+
        if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
                status = connector_status_disconnected;
 


