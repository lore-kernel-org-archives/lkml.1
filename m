Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXLLPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXLLPVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXLLPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:21:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45162
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755295AbXLLPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:21:24 -0500
Date: Wed, 12 Dec 2007 07:21:21 -0800 (PST)
Message-Id: <20071212.072121.93137990.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071211214634.4dedb274@freepuppy.rosehill>
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	<20071211213939.122de1db@freepuppy.rosehill>
	<20071211214634.4dedb274@freepuppy.rosehill>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Tue, 11 Dec 2007 21:46:34 -0800

> Isn't this a better fix for all drivers, rather than peppering every
> driver with the special case. This is how the logic worked up until
> 2.6.24.

Stephen this is not the problem.

The problem is that the driver is doing a NAPI completion and
re-enabling chip interrupts with work_done == weight, and that is
illegal.
