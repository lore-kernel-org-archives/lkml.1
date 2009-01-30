Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZA3WPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZA3WPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZA3WPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:15:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbZA3WPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:15:33 -0500
Date: Fri, 30 Jan 2009 14:15:31 -0800 (PST)
Message-Id: <20090130.141531.56578757.davem@davemloft.net>
To: w@1wt.eu
Cc: jarkao2@gmail.com, zbr@ioremap.net, herbert@gondor.apana.org.au,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090130221346.GE31355@1wt.eu>
References: <20090130215920.GC31355@1wt.eu>
	<20090130.140346.159984249.davem@davemloft.net>
	<20090130221346.GE31355@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Fri, 30 Jan 2009 23:13:46 +0100

> On Fri, Jan 30, 2009 at 02:03:46PM -0800, David Miller wrote:
> > Any NIC, even the dumbest ones, can be made to receive into pages.
> 
> OK I thought that it was not always easy to split between headers
> and payload. I know that myri10ge can be configured to receive into
> either skbs or pages, but I was not sure about the real implications
> behind that.

For a dumb NIC you wouldn't split, you'd receive directly, the
entire packet, into part of a page.

Then right befire you give it to the stack, you pull the ethernet
header from the page into the linear area.
