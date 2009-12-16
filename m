Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbZLPWUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbZLPWUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZLPWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:20:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:47720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762957AbZLPWUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:20:14 -0500
Date: Wed, 16 Dec 2009 14:15:41 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 1/1] devtmpfs: Convert dirlock to a mutex
Message-ID: <20091216221541.GA8707@suse.de>
References: <20091216212730.308081108@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216212730.308081108@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:31:33PM -0000, Thomas Gleixner wrote:
> devtmpfs has a rw_lock dirlock which serializes delete_path and
> create_path.
> 
> This code was obviously never tested with the usual set of debugging
> facilities enabled. In the dirlock held sections the code calls:
> 
>  - vfs functions which take mutexes
>  - kmalloc(, GFP_KERNEL)
> 
> In both code pathes the might sleep warning triggers and spams dmesg.
> 
> Convert the rw_lock to a mutex. There is no reason why this needs to
> be a rwlock.

Many thanks, this is correct.  I'll go queue it up.

greg k-h
