Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXLDMQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXLDMQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXLDMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:16:09 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:60190 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXLDMQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:16:08 -0500
X-Greylist: delayed 2077 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 07:16:07 EST
Date: Tue, 4 Dec 2007 12:41:25 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204114125.GA17310@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging Exim4's GnuTLS interface, I recently found out that
reading from /dev/urandom depletes entropy as much as reading from
/dev/random would. This has somehow surprised me since I have always
believed that /dev/urandom has lower quality entropy than /dev/random,
but lots of it.

This also means that I can "sabotage" applications reading from
/dev/random just by continuously reading from /dev/urandom, even not
meaning to do any harm.

Before I file a bug on bugzilla, can I ask why /dev/urandom wasn't
implemented as a PRNG which is periodically (say, every 1024 bytes or
even more) seeded from /dev/random? That way, /dev/random has a much
higher chance of holding enough entropy for applications that really
need "good" entropy.

Entropy depletion has become an issue on Linux systems since the
network was removed from the group of entropy sources a few years ago.
Of the around 20 Linux systems that I currently have root privileges
on, only two have a hardware RNG.

What can I do to keep sufficiently high entropy pools even if I read
from /dev/urandom more than once in a while?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
