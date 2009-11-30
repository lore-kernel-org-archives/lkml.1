Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZK3Kl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZK3Kl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZK3KlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:41:25 -0500
Received: from smtp.nokia.com ([192.100.122.233]:17727 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZK3KlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:41:25 -0500
Date: Mon, 30 Nov 2009 12:41:02 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Hogander Jouni (Nokia-D/Tampere)" <jouni.hogander@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Doubt about Regulator Framework and VBAT use case
Message-ID: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Nov 2009 10:41:09.0500 (UTC) FILETIME=[A0D1DBC0:01CA71A9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark and Liam,

I'm writing to ask about VBAT use case. What is the expected
way to use regulator framework in case of rail coming from battery?
Should it be added to the regulator framework at all?

In that case, the rail should not be controllable. So I don't see
any reason to add it to the regulator framework board definitions,
as we should not be controlling it.

However, drivers for devices on that rail would require their regulator anyway.
And I guess the point would be that drivers should not be aware that they are on VBAT
or any other rail.

So, what's the correct way to solve this?

- Should drivers fail nicely if a regulator_get fail? And continue even if one fails.
- Should drivers disable regfw usage completely in the driver if regulator_get doesn't
give valid regulator ?
- or Should a fake fixed regulator be added for vbat so drivers can still get a valid
regulator with regulator_get.

The last options seams to be the one that does not require much changes on drivers.
But it will be adding a regulator that does basically nothing in the system.

BR,

-- 
Eduardo Valentin
