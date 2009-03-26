Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZCZIVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZCZIVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZCZIVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:21:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36076 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbZCZIVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:21:34 -0400
Date: Thu, 26 Mar 2009 08:14:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Rolland <rol@as2917.net>
Cc: linux-kernel@vger.kernel.org, rol@as2917.net
Subject: Re: Linux 2.6.x - Serial port signalling not maintained when
 closing device
Message-ID: <20090326081431.0163e193@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326084220.4def5652@tux.DEF.witbe.net>
References: <20090326084220.4def5652@tux.DEF.witbe.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can see, I need to have an application that keeps /dev/ttyS0
> open for this to work. As soon as no application is using the port,
> everything goes down again.

Yes - the 2.6 kernel has the newer uart driver layer and is also
(throughout) much more aggressive about power management. You'll see the
same with magic electronic project parallel port hacks where the port is
turned off when the device file is not open.

> This is a significant change between 2.4.x and 2.6.x.

Only to your rather unusual use of things. For normal use the current
behaviour is far more correct.

> Is there a way to
> change 2.6.x behavior to go back to the 2.4.x ? When was this change
> introduce ?

Just keep the port open when you are using it. Even in 2.4 the driver
could have been unloaded on some setups if you didn't have a port open.

Alan
