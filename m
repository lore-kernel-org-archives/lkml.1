Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbXHFOua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbXHFOua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764118AbXHFOuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:50:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:42613 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbXHFOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O1T49Sbna8CIGqgv4OCyOXGvVcNJUQzQPTN37ThgJN0B1v/Wo+e/Q3GTr+QNHYD68Rcn9p0tD1JFunNH2QwGLT+uOmy4nwigZsXL18NYSfFberwZIc7gi8KAbLfTor9x98uHRCpQloTuB8s8+nN9a9jYTRESifZf2UgIoYcZlu0=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070806142339.GA31615@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <46B6B006.6000100@gmail.com> <20070806142339.GA31615@khazad-dum.debian.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Aug 2007 16:50:15 +0200
Message-Id: <1186411815.4355.7.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 06-08-2007, Pn o godzinie 11:23 -0300, Henrique de Moraes Holschuh
napisał(a):
> On Mon, 06 Aug 2007, Tejun Heo wrote:
> > Cc'ing Henrique.  Any ideas?
> 
> Check if /etc/init.d/halt is calling halt(8) with the -h flag.  If it is,
> remove that -h flag.  Usually, there is a hddown variable that holds it, you
> just need to get rid of it.
> 
> I don't know anything about a Sidux, though.

Well there is an -h variable:
# Don't shut down drives if we're using RAID.
	hddown="-h"
	if grep -qs '^md.*active' /proc/mdstat
	then
		hddown=""
	fi
....
log_action_msg "Will now halt"
	halt -d -f $netdown $poweroff $hddown
However removing it has no effect, the drive still spins down two times.

Sidux is a Debian Unstable based distro with it's own set of patches
including the shut down patch provided here:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224

Michael

