Return-Path: <linux-kernel-owner+w=401wt.eu-S1030881AbXDPQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881AbXDPQki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030880AbXDPQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:40:37 -0400
Received: from mail.suse.de ([195.135.220.2]:52256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030889AbXDPQkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:40:31 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Date: Mon, 16 Apr 2007 18:40:41 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200704161811.30364.agruen@suse.de> <20070416162146.GA8029@infradead.org>
In-Reply-To: <20070416162146.GA8029@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161840.41343.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 18:21, Christoph Hellwig wrote:
> But anyway, creating fake nameidata structures is not really helpful.
> If there is a nameidata passed people expect it to be complete, and
> if you pass them to an LSM people will e.g. try to look into lookup
> intents.

I don't actually agree with that: when nfsd creates a file, it still is a file 
create no matter where it originates from, and so it does make sense to 
provide the appropriate intent information too. Struct nameidata contains 
other crap only needed during an actual lookup too --- that's a mess, and the 
nameidata2 patch shows one possibility how to deal with it. (It's the 
cleanest approach I could think of right now without cluttering the vfs code 
with insane amounts of dereferences.)

Thanks,
Andreas
