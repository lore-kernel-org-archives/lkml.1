Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZDNFzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZDNFzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZDNFzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:55:01 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:59278 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZDNFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:55:01 -0400
Message-ID: <49E424A3.60606@cs.columbia.edu>
Date: Tue, 14 Apr 2009 01:52:35 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com>
In-Reply-To: <20090413214701.GA24509@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> 
> Hi Alexey,
> 
> as far as I can see, the main differences between this patch and the
> equivalent in Oren's tree are:
> 
> 1. kernel auto-selects container init to freeze

Actually, this eliminates the possibility to checkpoint a subtree of
tasks, which (under some obvious constraints) can be a handy feature.

> 2. kernel freezes tasks

IMHO better to do it in userspace - that way userspace can accomplish
other tasks while tasks are frozen, such as snapshot the filesystem,
or block/unblock the network.

Is there a good argument to do it kernel ?

> 3. no objhash taking references
> 4. no hbuf
> 5. always require CAP_SYS_ADMIN

I'm now convinced (thanks, Serge!) that it's better not to require
this unless we strictly have to.

Oren.


