Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYHCPkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYHCPkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYHCPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:39:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49935 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756052AbYHCPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:39:52 -0400
Date: Sun, 3 Aug 2008 16:22:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: petkovbb@gmail.com
Cc: petkovbb@googlemail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080803162214.394b13a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803143837.GA26672@gollum.tnic>
References: <20080715053356.GA18628@gollum.tnic>
	<200808021902.12191.bzolnier@gmail.com>
	<20080802183253.GA2239@gollum.tnic>
	<200808022046.16990.bzolnier@gmail.com>
	<20080803073756.GA8762@gollum.tnic>
	<20080803125907.67676948@lxorguk.ukuu.org.uk>
	<20080803143837.GA26672@gollum.tnic>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> conventions, it is still the best one considering the other possibilities:
> 
> a) code duplication: dumb idea, bloated kernel for no reason

I think you might want to start somewhere else if that worries you. Its
also a mostly bogus reasoning as almost nobody builds with both, in fact
you have to be pretty careful if you do that or it all falls over in a
heap.

For previous cases (eg ide timing) it has actually made more sense to
split the code. The moment you get future different behaviour between
libata and old IDE on any of these devices the sharing will just break
again (eg if one or the other drops chipset support for one of those
devices or adds one for another device)

> b) evil Kconfig SELECT pulling in core libata just so that ide might be calling
> a function or two.

That would be stunningly dumb. I happen to think we have developers whose
minds extent to adding libata-common.c and pulling in a single file if we
do that. Yes people have the past done stupid stuff like pulling all of
CONFIG_IDE in for a single USB device but that was because nobody noticed
and fixed it promptly not because it was a good idea.

Alan
