Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYCLFKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYCLFKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYCLFKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:10:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYCLFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:10:01 -0400
Date: Tue, 11 Mar 2008 22:08:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/6] kernel: add clamp(), clamp_t() and clamp_val()
 macros
Message-Id: <20080311220856.82e45072.akpm@linux-foundation.org>
In-Reply-To: <1205269894.22317.32.camel@brick>
References: <1205269894.22317.32.camel@brick>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 14:11:34 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Adds macros similar to min/max/min_t/max_t.
> 
> Also, change the variable names used in the min/max macros to
> avoid shadowed variable warnings when min/max min_t/max_t are
> nested.
> 
> clamp_val is useful when clamping to constants so all types are
> taken from typeof() the first arg.
> 
> Small formatting changes to make all the macros have a similar
> form.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, this is a rollup of my original patch already in -mm with
> checkpatch warnings fixed up and one additional macro based on
> limit_value found in the b43 driver, called clamp_val.

Well, this is why I dislike replacement patches.  You don't know what
changed, and the replacement patch can fail to incproporate fixes from
third parties.

>  include/linux/kernel.h |   66 ++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 48 insertions(+), 18 deletions(-)

And so it did.  You lost my patch which removes the clamp() implementation
from v4l.  Instead it seems that you put it into [2/6].  Which means that
this patch on its own will break the build, thus screwing up life for
git-bisect users.

Please don't screw up git-bisect users' lives.

> clamp_t is no longer used, but I introduce it anyway as some future
> user may want to force the return type similar to how min_t/max_t
> operate.

eh, just nuke it.

> 1.5.4.4.592.g32d4c

Is all this new infrastructure actually used?  We seem to be adding more
complexity than we're taking away.

