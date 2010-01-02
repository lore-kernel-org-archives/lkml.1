Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816Ab0ABQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0ABQea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 11:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764Ab0ABQe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 11:34:29 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38380 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab0ABQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 11:34:28 -0500
Subject: Re: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
       Helge Deller <deller@gmx.de>, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, roland@redhat.com, dave@hiauly1.hia.nrc.ca,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <2375c9f90912311908r667966e1m919430c40cd9c571@mail.gmail.com>
References: <87k4w4wux9.fsf@purkki.valot.fi>
	 <1262188157.2749.21.camel@mulgrave.site>
	 <2375c9f90912311908r667966e1m919430c40cd9c571@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 10:34:22 -0600
Message-Id: <1262450062.2741.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 11:08 +0800, Américo Wang wrote:
> This patch looks fine for me, except that I don't think it's necessary
> to introduce an inline function for that...

Actually, I really think we do.  The whole reason we got into this mess
in the first place is that it wasn't obvious from the code that if we
altered the loadability of sections, there were a ton of dependent
places we also had to update.  Putting all that knowledge into a single
inline makes the same mistake impossible to make because there's now
only one place to go to adjust the loadability of sections, and it
automatically takes care of all the dependencies.

> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks,

James


