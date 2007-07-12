Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGLIbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGLIbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXGLIa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:30:57 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:47383
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbXGLIa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:30:56 -0400
Message-Id: <46960319.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 12 Jul 2007 09:31:53 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <ambx1@neo.rr.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: pnp_assign_resources() issue
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam,

I'm having some difficulty understanding why failure to probe for a resource
(in the given case, a DMA channel, but the issue is perhaps more generic) must
always result in failure of the probing of the requesting device. In any case,
the driver is required to call request_dma(), and in many cases the driver may
know how to deal with the device even if that call fails (in the given case,
parport_pc can be used as an example). Shouldn't therefore pnp_assign_dma()
be made never fail, and just mark the resource as unset/disabled if none of
the options were available? I realize drivers may not really look at these flags,
but I'd think this is a driver issue then and shouldn't keep the framework
from supporting as many different systems as possible.

Thanks, Jan

