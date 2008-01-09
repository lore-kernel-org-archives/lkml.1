Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYAIWkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYAIWkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYAIWkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:40:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYAIWkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:40:33 -0500
Date: Wed, 9 Jan 2008 22:40:26 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109224026.GA4039@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Matt Mackall <mpm@selenic.com>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <1199909560.6245.67.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199909560.6245.67.camel@cinder.waste.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:12:40PM -0600, Matt Mackall wrote:
> You'll need to change the prototype, the unlocked version doesn't take
> an inode. And you'll need to make sure that nothing in the function uses
> the inode, which I think Andi forgot to mention.
 
This old chestnut again.  Perhaps we could have inode passed to unlocked_ioctl?
I never understood why it wasn't there in the first place if the plan was for
.unlocked_ioctl to supercede .ioctl whenever possible.

Device-mapper for example in dm_blk_ioctl(), has no need for BKL so drops it
immediately, but it does need the inode parameter, so it is unable to switch as
things stand.

Alasdair
-- 
agk@redhat.com
