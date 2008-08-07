Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYHGW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYHGW7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYHGW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:59:16 -0400
Received: from xes-mad.com ([216.165.139.214]:51150 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYHGW7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:59:15 -0400
Subject: Re: [PATCH] leds-pca955x: Add proper error handling and fix bogus
	memory handling
From: Nate Case <ncase@xes-inc.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: rpurdie@rpsys.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0808080041460.16201@titan.stealer.net>
References: <1210972198.13845.540.camel@localhost.localdomain>
	 <alpine.LNX.1.10.0808080041460.16201@titan.stealer.net>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:59:01 -0500
Message-Id: <1218149941.21619.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 00:45 +0200, Sven Wegener wrote:
> Check the return value of led_classdev_register and unregister all
> registered
> devices, if registering one device fails. Also the dynamic memory
> handling is
> totally bogus. You can't allocate multiple chunks via kzalloc() and
> expect
> them to be in order later. I wonder how this ever worked.

Yikes.  Good catch.  To be honest, I developed this for an embedded
system where it was always built into the kernel.  So the
pca955x_remove() case never would have been tested.  The assumption
about the chunks being in order probably came from a cut-and-paste from
another driver.

I'll test your patch and also build it as a module to make sure
unloading works properly.  Thanks.

-- 
Nate Case <ncase@xes-inc.com>

