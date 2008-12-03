Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYLCUgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYLCUgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbYLCUMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:12:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403AbYLCUMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:12:44 -0500
Date: Wed, 3 Dec 2008 15:12:03 -0500
From: Jason Baron <jbaron@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DEBUG_KOBJECT vs. DYNAMIC_PRINTK_DEBUG
Message-ID: <20081203201203.GA3128@redhat.com>
References: <20081202145251.6555d4cc@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202145251.6555d4cc@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 02:52:51PM +0100, Cornelia Huck wrote:
> DEBUG_KOBJECT has no effect when DYNAMIC_PRINTK_DEBUG is set
> (and you can get the messages via that feature), so let's make
> it depend on !DYNAMIC_PRINTK_DEBUG.
> 

indeed. you raise the more general question of what do if both 'DEBUG'
and 'CONFIG_DYNAMIC_PRINTK_DEBUG' are set for a file? I think that in
general the 'DEBUG' should take precedence, as you point out. However, I
think we should fix this by reshuffling the logic in
include/linux/kernel.h by doing:

if (DEBUG)
	#define pr_debug printk
elseif (CONFIG_DYNAMIC_PRINTK_DEBUG)
	#define pr_debug dynamic_pr_debug()
else
	#define pr_debug if (0) blah:
endif

make sense? what do you think?

thanks,

-Jason
