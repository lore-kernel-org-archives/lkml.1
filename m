Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbYDQOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbYDQOFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYDQOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:05:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46532 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbYDQOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:05:07 -0400
Date: Thu, 17 Apr 2008 10:05:06 -0400
To: Tejun Heo <htejun@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080417140506.GC7385@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <20080415144748.GO7385@csclub.uwaterloo.ca> <48053AD1.8010007@gmail.com> <200804162008.27655.elendil@planet.nl> <480679D3.7030705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480679D3.7030705@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 07:12:35AM +0900, Tejun Heo wrote:
> Asking when no harddisk is detected w/ the option to choose it 
> explicitly should do for most cases.  No?

I suppose it might, although I could still see an older machine have a
PCI controller as well as an ISA legacy controller on an ISA sound card,
and might even have a CDROM drive connected to the sound card.  Not very
likely though, but not imposible.  In that case you might detect the HD
connected to the HD, but not the CDROM connected to the sound card.
That might be confusing to the user.  On the other hand anyone running
such old hardware might just have a pretty good idea what they are doing
and could run in expert mode and tell the installer to also load the
generic driver.

I still think the correct solution is to always try loading it, posibly
with a boot option to make the installer not do so for any machines that
have issues with that.  Any such machines should then have bug reports
filed so that the driver that runs their chipset's IDE controller in a
native mode can ensure they reserve the legacy IDE ports so that nothing
else (like the generic driver) can go poking at them.

After all I thought the whole point of all the ports listed in
/proc/ioports was to indicate which io ports were currently reserved by
which driver so that no other driver could try to access them.  If it
doesn't in fact work that way then it probably should.

-- 
Len Sorensen
