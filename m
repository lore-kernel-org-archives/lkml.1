Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbXHFP1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbXHFP1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXHFP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:27:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:58644 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbXHFP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UOdSAnRghGFs+e6rgxoGi+Uyu8IaUUAJQjtn7SHppgMhVgzWLMS8ztI/+X8y+Xr3/CSdesj2Gmb+u5Dgn/NCUyKHouo7yyauSzR7TPojI9L2E1hrxiOtXmTQE4A8m+9iTBVAV3VM3W1gZjV0T0Osz5+AbqinfiELyjRFBvsEMMw=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070806150159.GC31615@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <46B6B006.6000100@gmail.com> <20070806142339.GA31615@khazad-dum.debian.net>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Aug 2007 17:27:14 +0200
Message-Id: <1186414034.5198.11.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 06-08-2007, Pn o godzinie 12:01 -0300, Henrique de Moraes Holschuh
napisał(a):
> On Mon, 06 Aug 2007, Michael Sedkowski wrote:
> > Dnia 06-08-2007, Pn o godzinie 11:23 -0300, Henrique de Moraes Holschuh
> > napisa??(a):
> > > On Mon, 06 Aug 2007, Tejun Heo wrote:
> > > > Cc'ing Henrique.  Any ideas?
> > > 
> > > Check if /etc/init.d/halt is calling halt(8) with the -h flag.  If it is,
> > > remove that -h flag.  Usually, there is a hddown variable that holds it, you
> > > just need to get rid of it.
> > > 
> > > I don't know anything about a Sidux, though.
> > 
> > Well there is an -h variable:
> > # Don't shut down drives if we're using RAID.
> > 	hddown="-h"
> > 	if grep -qs '^md.*active' /proc/mdstat
> > 	then
> > 		hddown=""
> > 	fi
> > ....
> > log_action_msg "Will now halt"
> > 	halt -d -f $netdown $poweroff $hddown
> > However removing it has no effect, the drive still spins down two times.
> 
> Nothing in Debian userspace will spin down the drive if you kill that -h, at
> least as far as I know.
> 
> > Sidux is a Debian Unstable based distro with it's own set of patches
> > including the shut down patch provided here:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224
> 
> You'll probably have to ask Sidux what changes they made that could cause
> the double spin down, even if halt(8) is never passed the -h flag.
> 
The double spin down problem occurs not only on Sidux, but on all
distros that I isued like Fedora 7, Mandriva, Debian or Ubuntu with
kernels ranging from 2.6.18 to 2.6.22. I only use the Sidux because they
released the shut down patch required to shut down properly on the
2.6.22 kernel line and on two other systems the drives are turned off
nicely [standard Debian still runs on the old shut down scripts. On that
basis I believe that this is a HP (Intel?) issue not related to any
particular distro.


