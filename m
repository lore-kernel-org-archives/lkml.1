Return-Path: <linux-kernel-owner+w=401wt.eu-S934455AbXILL5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455AbXILL5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765769AbXILL5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:57:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55180 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765640AbXILL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:57:00 -0400
X-Auth-Info: ePAFGOS3DRqgAy5MDjd6QFAmK8luteI51EJ434uQ3no=
X-Auth-Info: ePAFGOS3DRqgAy5MDjd6QFAmK8luteI51EJ434uQ3no=
X-Auth-Info: ePAFGOS3DRqgAy5MDjd6QFAmK8luteI51EJ434uQ3no=
X-Auth-Info: ePAFGOS3DRqgAy5MDjd6QFAmK8luteI51EJ434uQ3no=
X-Auth-Info: NgyqaZY5AVTbVLigvZ8lY6JEtPu/a1yc26XEJ8ovkqs=
X-Auth-Info: NgyqaZY5AVTbVLigvZ8lY6JEtPu/a1yc26XEJ8ovkqs=
Subject: Re: SYSFS: need a noncaching read
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
To: Greg KH <greg@kroah.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Detlev Zundel <dzu@denx.de>
In-Reply-To: <20070912113907.GA24087@kroah.com>
References: <1189503798.6674.46.camel@Zeus.EmbLux>
	 <20070912053207.GH23573@pengutronix.de> <20070912100123.GA23182@kroah.com>
	 <1189595612.6659.23.camel@Zeus.EmbLux>  <20070912113907.GA24087@kroah.com>
Content-Type: text/plain
Organization: DENX
Date: Wed, 12 Sep 2007 13:59:40 +0200
Message-Id: <1189598380.6659.28.camel@Zeus.EmbLux>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Am Mittwoch, den 12.09.2007, 04:39 -0700 schrieb Greg KH:
> > > Do an lseek back to 0 and then re-read, you will get called in your
> > > driver again.
> > 
> > No thats not true. I thought this too, but if I make a:
> > 
> > seek (fd, 0L, SEEK_SET);
> > 
> > in Userspace, there is no retrigger in the sysFS, my driver is *not*
> > called again. So I made a own sysfs_seek function, which does retrigger
> > the driver ...
> 
> Hm, are you sure?  Otherwise the poll() stuff would not work at all.

Yes.
Sysfs uses generic_file_llseek (). And in sysfs_read_file ()
buffer->needs_read_fill must be 1, to reread from the driver.
generic_file_llseek () doesnt change this variable.

Best regards
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

