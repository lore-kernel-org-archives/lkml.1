Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXIEJzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXIEJzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXIEJze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:55:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39128 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXIEJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:55:33 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 5 Sep 2007 05:42:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
In-Reply-To: <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709050536410.31804@localhost.localdomain>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
 <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
 <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Jan Engelhardt wrote:

>
> On Sep 5 2007 11:37, Michal Piotrowski wrote:
> >
> >Hi,
> >
> >[Adding K{build,config} wizards to CC]
> >
> >On 05/09/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >>
> >> $ make distclean
> >> $ make defconfig
> >> $ make menuconfig      (select visor.ko to be built a module)
> >> $ make drivers/usb/serial/visor.ko
>
> Beep. Need 'make scripts prepare' between menuconfig and visor.

that doesn't solve the problem.  i should have mentioned that i
already (unnecessarily, i suggest) ran "make modules_prepare", but the
problem persists.

the issue seems to be that running that last make command to build the
module visor.ko doesn't somehow signal the Makefile that this is a
*module* build, and therefore no module-related initialization is
done, such as creating that directory or setting the Makefile variable
MODVERDIR, etc, etc.

once you've build at least one module successfully, then the directory
.tmp_versions exists so future module builds will work fine.  it's
only when you do a clean, *immediately* followed by trying to do an
in-tree module build, that this is going to bite you.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
