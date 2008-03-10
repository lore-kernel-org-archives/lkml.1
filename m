Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYCJW0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYCJW0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYCJW0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:26:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYCJW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:26:44 -0400
Date: Mon, 10 Mar 2008 23:28:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: locking for tty_wait_until_sent
Message-ID: <20080310222835.GC9246@one.firstfloor.org>
References: <20080310215325.2b8d33e8@core> <87od9m5iu4.fsf@basil.nowhere.org> <20080310220643.60f36bee@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310220643.60f36bee@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 10:06:43PM +0000, Alan Cox wrote:
> On 10 Mar 2008 23:12:51 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > > This function still depends on the big kernel lock in some cases. Push
> > > locking into the function ready for removal of the BKL from ioctl call
> > > paths.
> > 
> > Didn't you forget the .ioctl -> .unlocked_ioctl change?
> 
> We are not yet ready to unlock the device ioctl paths for tty. We still

Traditionally the usual is to first convert .ioctl to .unlocked_ioctl
and just slap lock_kernel around the whole ioctl handler and then 
later move it down step by step.

I didn't read the code completely but I assume tty_ioctl would be that
handler. I guess i was wrong?

-Andi
