Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbZAPMGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbZAPMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZAPMGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:06:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38882 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbZAPMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:06:34 -0500
Date: Fri, 16 Jan 2009 13:08:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul.Clements@steeleye.com
Subject: Re: nbd: add locking to nbd_ioctl
Message-ID: <20090116120843.GA29971@elf.ucw.cz>
References: <20090116115512.GA10771@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116115512.GA10771@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 12:55:12, Pavel Machek wrote:
> 
> The code was written with "oh big kernel lock, please protect me from
> all the evil" mentality: it does not locks its own data structures, it
> just hopes that big kernel lock somehow helps.
> 
> It does not. (My fault).
> 
> So this uses tx_lock to protect data structures from concurrent use
> between ioctl and worker threads.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Ok, it should return -EINVAL at the end of __nbd_ioctl. But Paul, does
it look ok otherwise?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
