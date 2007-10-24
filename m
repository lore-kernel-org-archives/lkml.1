Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbXJXF1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbXJXF1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXJXF1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:27:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:2308 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbXJXF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:27:21 -0400
Message-ID: <fa686aa40710232227x7984097bk8bc55fe6cf194d63@mail.gmail.com>
Date: Tue, 23 Oct 2007 23:27:21 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Domen Puncer" <domen.puncer@telargo.com>
Subject: Re: [PATCH] mpc5200: psc-spi driver must not touch port_config or cdm registers
Cc: "Dragos Carp" <dragos.carp@toptica.com>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <20071024050100.GA3369@nd47.coderock.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024033457.8657.8708.stgit@trillian.cg.shawcable.net>
	 <20071024050100.GA3369@nd47.coderock.org>
X-Google-Sender-Auth: 3383967f098a4a3a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Domen Puncer <domen.puncer@telargo.com> wrote:
> On 23/10/07 21:39 -0600, Grant Likely wrote:
> > From: Grant Likely <grant.likely@secretlab.ca>
> >
> > port_config and the cdm are the responsibility of firmware; and if
> > firmware doesn't set it up correctly, it should be fixed up by
> > platform code on a per-board basis because it's a property of the
> > board.
> >
> > Drivers should never touch these registers.  They are completely
> > unprotected and the platform may do odd things with them that the
> > driver must not interfere with.
> >
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >
> > Domen, Dragos; can you please check your usage of this driver.  None of
> > the in-tree board ports use it as-is, but they are of course just a
> > device tree change away from being usable on the lite5200b.
>
> My test cases were just a jumper on RX-TX line.
>
> It's not even allowed to set mclken_div_pscX?
> There can be different speed devices on same SPI
> (spi_board_info->max_speed_hz).

Nope; do it in the platform code or a cdm driver.  Otherwise there is
no protection against collisions on the cdm registers.  The driver
could call a platform hook to fiddle with clocking, but it must not
touch it directly.

(BTW, I don't intended to push this version of the patch; I just want
to get everyone's brain juices flowing to figure out the best way to
solve it.)

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
