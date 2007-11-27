Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbXK0Uoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbXK0Uoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXK0Uof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:44:35 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1806 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbXK0Uoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:44:34 -0500
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: 2.6.23-mm1 tg3 wake-on-lan oddity...
From: "Michael Chan" <mchan@broadcom.com>
To: Valdis.Kletnieks@vt.edu
cc: linux-kernel@vger.kernel.org, "netdev" <netdev@vger.kernel.org>
In-Reply-To: <24400.1196156118@turing-police.cc.vt.edu>
References: <24400.1196156118@turing-police.cc.vt.edu>
Date: Tue, 27 Nov 2007 13:34:57 -0800
Message-ID: <1196199297.7323.10.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6B525E2D1S412257467-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 01:35 -0800, Valdis.Kletnieks@vt.edu wrote:

> 
> Issue:
> 
> I (for unrelated reasons) run powertop, and it suggests I conserve power
> by doing 'ethtool -s eth0 wol d'.  I look at it, and think that it's daft,
> because (a) the Dell factory default is WOL disabled and (b) if it wasn't
> the default, I'd have *set* it to disabled, and (c) I even went back and
> rebooted and checked the BIOS setting - disabled. Nonetheless:
> 
> # ethtool eth0 | grep Wake
>         Supports Wake-on: g
>         Wake-on: g
> 
> Is this expected behavior?

What's happening is that there are 2 WoL settings: one in the BIOS and
one in the NIC's NVRAM.  For WoL to work, I think both settings have to
be enabled.  Apparently in this case, when you turn off WoL in the BIOS,
the NVRAM's WoL setting is unchanged, and will be seen by tg3 as
enabled.

Ideally, the BIOS should modify the NVRAM's setting when it is changed.
We will talk to Dell to get their opinion on this as this is very
confusing to the user.

Thanks.

