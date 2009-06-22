Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZFVM0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZFVM0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZFVM0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:26:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42617 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFVM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:26:47 -0400
Date: Mon, 22 Jun 2009 13:26:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Aggarwal, Anuj" <anuj.aggarwal@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Message-ID: <20090622122643.GB4495@sirena.org.uk>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0305AE7362@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0305AE7362@dbde02.ent.ti.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regulator enable called without increasing the use_count
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 05:06:36PM +0530, Aggarwal, Anuj wrote:

> Why is it designed like that? Should I enable it again and then call the 
> disable()?

It's like that because regulators can be shared between mulitple
consumers.  In order for that to work consumers can't disable regulators
they didn't enable themselves (since otherwise they could be breaking
another consumer) and so the can't increase the reference count.

If your driver explicitly needs the regulator to be off at startup it
should do an enable then a disable.  Otherwise it should just leave the
regulator alone.  Machines can call regulator_has_full_constraints() to
tell the core that any regulators which have not been explicitly enabled
by consumers can be powered off at the end of init - at some point in
the future this will become the default.
