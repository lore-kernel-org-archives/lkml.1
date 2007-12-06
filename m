Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXLFVPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXLFVPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXLFVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:15:06 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:36880 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751137AbXLFVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:15:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=5e+j+sLRdLGpDJxcLTdr7/uzndn8Vf+gKXVyPHWMGTsux6oso2pRc7GPulWvjtv0Rv5XzjLPgLAIx1VYDjIRWe0r+yOMfQUFhg6G+Ag8dSeI3/S6uZ8YPy381halxWDAFHf+Sdd5vP/chRqpwPfcaSW+DOVO/0DnabH3TwXBzOU=  ;
X-YMail-OSG: zTKSzmcVM1nGaEXYZvnDPZHcr0jtR.GIuDiNYCC0i35.qu6ldpVk38WlPPnHURxoX5fjJg_7Uw--
Date: Thu, 6 Dec 2007 22:13:35 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] swap image signature check upon resume
Message-ID: <20071206211335.GA4923@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Pavel Machek <pavel@suse.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,
hi Rafael,

after a quick search i couldn't find anything dealing with the topic in the
subject line so here we go:

One sometimes can mix up (and by one i mean me) the
kernel images one boots after having suspended the machine previously. There can
be at least two reasons for that:

1. too many kernels in grub and having forgotten with which i suspended.
2. compile and install a new kernel and forget about it, suspend in the evening
and then boot with the new kernel;

in both cases you end up staring at fsck since they filesystems haven't been unmounted,
of course. Or at least see the warning message of some journal recovery whisk away.

In order to alleviate that, one could probably go, imho, and write in the swsusp_header
the kernel version which suspended the machine (UTS_RELEASE) alongside
SWSUSP_SIG and check that against the kernel version of the image just booting.
If they match then all is well, if not, one could

a) issue a BIG FAT WARNING and reboot telling the user to select the proper
image
b) ask the user what to do:
	- proceed as if "noresume" has been entered on the kernel command line
	- reboot after issuing the kernel version which suspended the machine
	-
c)...

In case you guys think something like that might be of use i can come up with a
patch in the next coupla days...

-- 
Regards/Gruﬂ,
    Boris.
