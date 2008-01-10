Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYAJJXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYAJJXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYAJJWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:22:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYAJJWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:22:54 -0500
Date: Thu, 10 Jan 2008 10:25:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080110092528.GA25076@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <200801100952.55039.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801100952.55039.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you explain the rationale behind that running on the BKL? What type of 

It used to always run with the BKL because everything used to 
and originally nobody wanted to review all ioctl handlers in tree to see if 
they can run with more fine grained locking. A lot probably can though.

> things needs to be protected so that this huge hammer is needed? What would 
> be an earlier point to release the BKL?

That depends on the driver. A lot don't need BKL at all and 
in others it can be easily eliminated. But it needs case-by-case
review of the locking situation.

The goal of the proposal here is just to make it more visible.

-Andi
