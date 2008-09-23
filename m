Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYIWVFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYIWVFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYIWVFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:05:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47731
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbYIWVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:05:31 -0400
Date: Tue, 23 Sep 2008 14:05:19 -0700 (PDT)
Message-Id: <20080923.140519.268233735.davem@davemloft.net>
To: jkosina@suse.cz
Cc: david.vrabel@csr.com, airlied@gmail.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
References: <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
	<20080922.185902.80812984.davem@davemloft.net>
	<alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 23 Sep 2008 16:29:16 +0200 (CEST)

> On Mon, 22 Sep 2008, David Miller wrote:
> 
> > So I went through the changes from 2.6.27-rc5 until the SHA1
> > ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
> > definitely no E1000 or E1000E changes during that time.
> 
> Some recent comments on [1] seem to indicate that this is somehow coupled 
> into prior problems/panics with Intel graphics. 

My current suspicion in all of this is either the GEM kernel patches
or recent X server.

However, the eeprom/nvram programming sequence seems non-trivial on
the e1000e.  You have to execute a set of precise register writes
and register polls to successfully write things out to the nvram.

This makes something like a random scribble out to MMIO space less
likely to cause this problem.

Is there some linear mapping of the nvram that could be written to
on these cards?
