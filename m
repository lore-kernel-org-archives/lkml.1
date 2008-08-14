Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYHNPQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYHNPQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYHNPQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:16:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35326 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYHNPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:16:36 -0400
Subject: Re: [Devel] Re: [RFC][PATCH 1/4] checkpoint-restart:
	general	infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <48A3E81C.6010008@openvz.org>
References: <20080807224033.FFB3A2C1@kernel>
	 <20080807224034.735B1F84@kernel>	<200808081146.54834.arnd@arndb.de>
	 <1218221451.19082.36.camel@nimitz> <489CB3CA.6050304@cs.columbia.edu>
	 <48A3E81C.6010008@openvz.org>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 08:16:17 -0700
Message-Id: <1218726977.23641.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:09 +0400, Pavel Emelyanov wrote:
> E.g. consider we are saving a container image on ipv6 node and trying 
> to restore from it on the one without the ipv6. In that case we *may*
> have some object of for example CKPT_IPV6_IFA type of CLPT_IPV6_SOCK_INFO
> and fail the restoration process when finding such in an input file. But 
> what we should *not* do is to write any information about whether we had
> the CONFIG_IPV6 turned on on the dumping side and check for this on the
> restoring side.

The only problem I can see with this is that you lose efficiency,
especially when you have to build your checkpoint image with lots of
things that are config-specific.

The approach sounds like a good one in theory, but I'm a bit skeptical
that we could stick to it in practice, in a mainline kernel where there
are billions of config options.  It is definitely something to strive
for, though.  Good point!

-- Dave

