Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYFMNY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYFMNY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYFMNYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:24:50 -0400
Received: from baikonur.stro.at ([213.239.196.228]:42524 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYFMNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:24:50 -0400
Date: Fri, 13 Jun 2008 15:21:47 +0200
From: maximilian attems <max@stro.at>
To: "Klaus S. Madsen" <ubuntu@hjernemadsen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] hdaps add support for various IBM thinkpads R61/T61/T61P
Message-ID: <20080613132147.GG7212@baikonur.stro.at>
References: <1213356407-1220-1-git-send-email-max@stro.at> <20080613114002.GJ30713@42.dk> <20080613122751.GF7212@baikonur.stro.at> <20080613124543.GK30713@42.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613124543.GK30713@42.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 02:45:43PM +0200, Klaus S. Madsen wrote:
> On Fri, Jun 13, 2008 at 14:27:51 +0200, maximilian attems wrote:
> > On Fri, Jun 13, 2008 at 01:40:02PM +0200, Klaus S. Madsen wrote:
> > > On Fri, Jun 13, 2008 at 13:26:47 +0200, maximilian attems wrote:
> > > > diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
> > > > index 26df06f..e07c712 100644
> > > > --- a/drivers/hwmon/hdaps.c
> > > > +++ b/drivers/hwmon/hdaps.c
> > > > @@ -515,6 +515,7 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
> > > >  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
> > > >  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
> > > >  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
> > > > +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R61"),
> > > >  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
> > > >  	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
> > > >  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
> > > > @@ -523,6 +524,8 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
> > > >  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
> > > >  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
> > > >  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
> > > > +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61"),
> > > > +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61P"),
> > > I would suspect that this part of the patch is unnecessary. It would be
> > > strange if there are any T61's where the manufacturer is IBM, instead of
> > > LENOVO, since the T60 is older and has the manufacturer listed as
> > > LENOVO, and no entry exists for IBM.
> > > 
> > > But according to the comment at the top of the struct, the second line
> > > (the T61P part) is unnecessary, as a T61p already would be matched by
> > > the T61 line. 
> > 
> > according to hardy git there is no bug reference, but the T61p got added
> > before the T61 both by chuck. could you enlighten us please on the T61
> > IBM match need? 
> I believe that this patch is a response to
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/133636
> 
> But as I stated in that bug description, the fix did not work for me.
> Also both R61, T60, T61 and T61p owners responded that their
> dmi-manufacturer was listed as LENOVO. So I'm quite dubious if these
> entries will match any machines at all?

ok thanks for fisching the reference,
launchpad is still quite an allien biest for me.

according to the bug report missing is R61, T61p, X61, Z61m, Z61p
will test belows on an X61.

diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index 26df06f..586e412 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -516,17 +516,22 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
 	{ .ident = NULL }
 };
 
