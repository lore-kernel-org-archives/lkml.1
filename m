Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbZEZXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbZEZXWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbZEZXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:19:17 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36814 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbZEZXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:19:16 -0400
Date: Wed, 27 May 2009 08:19:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
Message-ID: <20090526231902.GA6295@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
	linux-mtd@lists.infradead.org
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org> <1243331191-11445-2-git-send-email-vapier@gentoo.org> <20090526113122.GB16835@linux-sh.org> <8bd0f97a0905260942m4b574d75oc4f38ee3d8849395@mail.gmail.com> <20090526164735.GA24261@linux-sh.org> <8bd0f97a0905260950i6da64210n7da256627d3e38ff@mail.gmail.com> <20090526170653.GB24261@linux-sh.org> <8bd0f97a0905261024q178fbc80n4a997daca5a3b405@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0905261024q178fbc80n4a997daca5a3b405@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 01:24:46PM -0400, Mike Frysinger wrote:
> On Tue, May 26, 2009 at 13:06, Paul Mundt wrote:
> > Use the attached, and then just set uclinux_ram_map.phys = your_address_here
> > in your setup_arch(). Having weak symbols in drivers that are supposed to
> > be overriden by the architecture code is just way too backwards for
> > words. Globals suffice fine for this sort of thing, if you are not going
> > to go to the effort to pass this information to the driver directly that
> > is.
> 
> i was thinking something else, but obviously this is nicer than what i
> was thinking

Unfortunately there is the problem that the map driver itself is a
tristate, so if this is built as a module, the symbol will not be
available to you. On the other hand, if it doesn't need to ever really be
a module, converting it to a bool ought to be workable. There are no
in-tree users that enable this as a module anyways.
