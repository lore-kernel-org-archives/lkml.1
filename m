Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYIPW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYIPW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:27:11 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:11304
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbYIPW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:27:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocBAGPPz0h8qNU+/2dsb2JhbAAIuhuBZw
X-IronPort-AV: E=Sophos;i="4.32,410,1217779200"; 
   d="scan'208";a="321698625"
Subject: Re: Driver for tightly coupled memory
From: Ben Nizette <bn@niasdigital.com>
To: Alessio Sangalli <alesan@manoweb.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48CFEF3F.5040901@manoweb.com>
References: <48CEC71F.3000006@manoweb.com>
	 <20080916093513.GF1916@fluff.org.uk>  <48CFEF3F.5040901@manoweb.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 17 Sep 2008 08:27:02 +1000
Message-Id: <1221604022.3598.4.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-16 at 10:39 -0700, Alessio Sangalli wrote:
> Ben Dooks wrote:
> > IIRC, there's no current support for using TCMs.
> 
> I think I will write a module that implements a software FIFO. One
> function to allocate a FIFO n words deep, a "push" and a "pop" and
> similar. The calling module will have to setup the FIFO and use it
> probably in ISRs or similar (the policy will totally remain in the
> caller module). Any comments on such approach?

I'd feel uncomfortable about picking an arbitrary function for the TCM
to accomplish.  Why don't you just set up a genalloc on that RAM and let
the user use it for what they will?

If a driver needs a quick FIFO it can attempt to get the RAM for said
FIFO from the genalloc and fall back to main memory otherwise.  Simple,
flexible, easy :-)

	--Ben.
