Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZFWKhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZFWKhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZFWKh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:37:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52931 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZFWKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:37:25 -0400
Date: Tue, 23 Jun 2009 11:37:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Message-ID: <20090623103717.GH5422@sirena.org.uk>
References: <20090622234607.11f61bec@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622234607.11f61bec@mycelium.queued.net>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
 add it to the olpc driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:46:07PM -0400, Andres Salomon wrote:

> The hardware has an extra bit that specifies that the battery is trickle
> charging, so when determining if the battery is present/charging the TRICKLE
> bit needs to be checked as well.  Because battery diagnostics might want to
> know whether trickle charging is happening or not, and also because trickle
> charging falls somewhere between charging and not charging (read: Richard got
> mad at me when I tried to set CHARGING when in trickle charge.  He gets so
> angry sometimes), we add a new TRICKLE status to sysfs.

To avoid confusing usere applications might it be better to add another
piece of information with detail on the charger status rather than a new
state?  The fact that the new state name shares a prefix with the
regular charging state does help here but you might still confuse things
and it makes the name of the new state in sysfs a bit awkward.

I'd also be tempted to do this the other way around and add a fast
charge status; certainly in embedded cases trickle charging is more of a
default state since it requires less incoming power (important if you're
using USB) and there's less risk of damage to the battery.
