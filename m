Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZA3Kay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZA3Kay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZA3Kaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:30:46 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:51327 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZA3Kap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:30:45 -0500
Date: Fri, 30 Jan 2009 11:30:43 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: kay.sievers@vrfy.org, greg@kroah.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
Message-ID: <20090130113043.72fd0f55@gondolin>
In-Reply-To: <d82e647a0901300217s73a6a295sa61232bac8c95115@mail.gmail.com>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
	<20090130110555.116f747a@gondolin>
	<d82e647a0901300217s73a6a295sa61232bac8c95115@mail.gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 18:17:36 +0800,
Ming Lei <tom.leiming@gmail.com> wrote:

> If probing done does not mean the device is available, this patch should be
> ignored or fixed further.
> 
> But polling is really not good, is there a approach to avoid the polling for
> appearence of the root device?

I think the parts of your patch that replace polling for
driver_probe_done() with waiting on the waitqueue are fine. The
problematic part is the rootwait special case, where polling seems
unavoidable afaics.
