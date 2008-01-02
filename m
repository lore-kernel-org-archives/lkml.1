Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYABUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYABUeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYABUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:34:14 -0500
Received: from verein.lst.de ([213.95.11.210]:44441 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbYABUeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:34:14 -0500
Date: Wed, 2 Jan 2008 21:33:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: getting rid of filp search in fs_may_remount_ro()
Message-ID: <20080102203357.GB884@lst.de>
References: <20071126135220.GA17244@lst.de> <20071226141214.GA31455@lst.de> <1199130866.13731.27.camel@localhost> <1199141688.13731.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199141688.13731.35.camel@localhost>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 02:54:48PM -0800, Dave Hansen wrote:
> Here's one blatantly untested idea I have.  The idea is to keep track if
> anyone might be writing to a mnt.  We keep track on a flag in the mnt.
> When we set the flag, we increment a counter in the sb and decrement
> when the flag is cleared.
> 
> We can't simply look at mnt->__mnt_writers because there might be
> "checked-out" writers in the mnt_writers[] array.  We also have to keep
> new writers from coming in while we do this, so we use the spinlocks in
> the mnt_writers[] array for exclusion.  This is a pretty heavyweight
> lock, but it only gets used at rw->ro transitions.

This idea looks good to me, but if you're going to a final version
please just inline fs_may_remount_ro into its only caller.

