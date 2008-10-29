Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYJ2X4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYJ2X4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJ2X4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:56:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50904 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYJ2X4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:56:17 -0400
Date: Wed, 29 Oct 2008 23:56:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, ncunningham@crca.org.au,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Message-ID: <20081029235600.GA5993@srcf.ucam.org>
References: <E1KvDcp-0008B7-SR@pomaz-ex.szeredi.hu> <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:37:30PM -0400, Alan Stern wrote:

> I discussed this last summer with Rafael.  It's a lot harder than it 
> looks, for all sorts of reasons.  For example, what about user tasks 
> that have access to memory-mapped I/O regions?

The only interesting cases of this I know of are X (which ought to stop 
doing so in the near future) and certain sound operations (which are 
going via a well-defined API anyway and need to handle devices going 
away at random, so not a problem). There may be some other niche cases, 
but really - if you're mmapping hardware then it's generally because you 
haven't written a proper kernel driver. Do that instead. Runtime power 
management's already going to make you wildly unhappy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
