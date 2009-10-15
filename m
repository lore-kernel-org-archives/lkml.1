Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZJOApk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZJOApk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbZJOApj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:45:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53785 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZJOApi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=skm9TEv6KvRvt9Y3tpVp9hBqsv5I4LgCCXcCicLP/Ssl0G7KsnvqnvWa+JTHzIkRSC
         gQD/2lICZ7NCXvvJk8Uekpe+6CHgbfmPlz0mXIsaM1PEASkDTRNM6j9Pzs14u2IM9VPh
         4UXwFfitUt7NN1G8dA0kyy9dGBzrqs6UN6sNQ=
Date: Wed, 14 Oct 2009 17:44:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091015004451.GA2872@core.coreip.homeip.net>
References: <20091013182643.GC21593@core.coreip.homeip.net> <20091013190819.GA7555@Pilar.aei.mpg.de> <20091013194654.GD21593@core.coreip.homeip.net> <20091013202459.GE21593@core.coreip.homeip.net> <20091013231641.GA4404@Pilar.aei.mpg.de> <20091013235607.GA28819@core.coreip.homeip.net> <20091013235701.GB28819@core.coreip.homeip.net> <20091014005131.GA4371@Pilar.aei.mpg.de> <20091014023008.GA29672@core.coreip.homeip.net> <20091014111325.GA4586@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014111325.GA4586@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 01:13:25PM +0200, Carlos R. Mafra wrote:
> On Tue 13.Oct'09 at 19:30:08 -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 14, 2009 at 02:51:31AM +0200, Carlos R. Mafra wrote:
> > > On Tue 13.Oct'09 at 16:57:01 -0700, Dmitry Torokhov wrote:
> > > > On Tue, Oct 13, 2009 at 04:56:08PM -0700, Dmitry Torokhov wrote:
> > > > > On Wed, Oct 14, 2009 at 01:16:41AM +0200, Carlos R. Mafra wrote:
> > > > > > [restoring Cc: list]
> > > > > > 
> > > > > > On Tue 13.Oct'09 at 13:24:59 -0700, Dmitry Torokhov wrote:
> > > > > > >
> > > > > > > Could you please try this patch (again if you could post dmesg that
> > > > > > > would be great). Thank you!
> > > > > > 
> > > > > > The patch quoted below also fixes the problem. I attached the
> > > > > > syslog with i8042.debug (with a s2ram in the middle) to the
> > > > > > bugzilla: 
> > > > > > 
> > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=14392
> > > > > > 
> > > > > 
> > > > > Still not quite happy, although it is better. I don't understand why
> > > > > your box likes to reply on AUX port when command is sent via keyboard
> > > > > port.
> > > > > 
> > > > > Could you please try booting with atkbd.reset (I assume keyboard is
> > > > > built in) and send me yet another dmesg.
> > > > > 
> > > > 
> > > > Oh, yes, keep the last patch applied. Thanks!
> > > 
> > > I uploaded the dmesg with atkbd.reset (and i8042.debug too, btw)
> > > to the bugzilla.
> > > 
> > 
> > Hmm, this is messed up... For some reason your box insists on replying
> > to reset commands from AUX port, no matter what device we trying to
> > reset. Does your box (Vaio, right?) has external PS/2 ports? I don't
> > believe Vaios have docking stations... 
> 
> My Vaio has no PS/2 port and no docking station.
> 
> > Also, could you please boot with
> > i8042.nomux and send me yet another dmesg and dmidecode too.
> 
> Ok, they are in the kernel bugzilla #14392 now.
> 
> > Thanks for your patience.
> 
> I thank _you_ for digging the problem even further. Your proposed patch
> "fixed" it already for me, but you are being honest in saying that
> you are still not happy with your fix and want to do better. I really
> appreciate that and will help you with what I can do. I hope there is
> a way out of my Vaio's oddities.

Ok, so here is hopefullt the last patch, it automatically disables MUX
mode on your Vaio since it is broken (you still need the previous patch
that changes atkbd since - there are 2 diffrent issues). I'd appreciate
if you could test it - if it works then you should see mention of only 2
serio ports in your dmesg and not 5.

Thanks!

-- 
Dmitry


Input: i8042 - add Sony Vaio VGN-FZ240E to the nomux list

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

On this model, when KBD is in active multiplexing mode, acknowledgements
to reset and get ID commands issued on KBD port sometimes are delivered
to AUX3 port (touchpad) which messes up device detection. Legacy KBC
mode works fine and since there are no external PS/2 ports on this laptop
and no support for docking station we can safely disable active MUX mode.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042-x86ia64io.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 77ff205..a537925 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -327,6 +327,17 @@ static struct dmi_system_id __initdata i8042_dmi_nomux_table[] = {
 		},
 	},
 	{
+		/*
+		 * Reset and GET ID commands issued via KBD port are
+		 * sometimes being delivered to AUX3.
+		 */
+		.ident = "Sony Vaio FZ-240E",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
+		},
+	},
+	{
 		.ident = "Amoi M636/A737",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
