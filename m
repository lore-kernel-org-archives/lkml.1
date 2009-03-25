Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZCYCEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZCYCEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZCYCE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:04:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34115
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbZCYCE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:04:27 -0400
Date: Tue, 24 Mar 2009 19:04:14 -0700 (PDT)
Message-Id: <20090324.190414.59071734.davem@davemloft.net>
To: holt@sgi.com
Cc: chuck.lever@oracle.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kernel unaligned accesses on 2.6.29.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325011418.GB8908@sgi.com>
References: <20090324172856.GA8908@sgi.com>
	<20090325011418.GB8908@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Tue, 24 Mar 2009 20:14:18 -0500

> You either need to use memcpy, or not define it as an unsigned char.
> Tony, any suggestions?

memcpy() might not work in this scenerio.

GCC can still emit an inline 64-bit memory access if it
deems that the objects involved should be sufficiently
aligned.

It might not be able to in this specific case, but it is
something to be aware of.  Don't be convinced of any fix
for this until the assembler is inspected by hand :-)
