Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYAIWnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYAIWnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYAIWnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:43:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYAIWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:43:31 -0500
Date: Wed, 9 Jan 2008 23:46:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alasdair G Kergon <agk@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109224603.GH15612@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109224026.GA4039@agk.fab.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:40:26PM +0000, Alasdair G Kergon wrote:
> On Wed, Jan 09, 2008 at 02:12:40PM -0600, Matt Mackall wrote:
> > You'll need to change the prototype, the unlocked version doesn't take
> > an inode. And you'll need to make sure that nothing in the function uses
> > the inode, which I think Andi forgot to mention.
>  
> This old chestnut again.  Perhaps we could have inode passed to unlocked_ioctl?
> I never understood why it wasn't there in the first place if the plan was for
> .unlocked_ioctl to supercede .ioctl whenever possible.

If you still need inode use

struct inode *inode = file->f_dentry->d_inode;

-Andi

