Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZALD6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZALD6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZALD6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:58:45 -0500
Received: from thunk.org ([69.25.196.29]:60172 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZALD6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:58:44 -0500
Date: Sun, 11 Jan 2009 22:58:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>, Akinobu Mita <akinobu.mita@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adilger@sun.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Message-ID: <20090112035835.GA16898@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, adilger@sun.com,
	linux-ext4@vger.kernel.org
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com> <20090111020352.GA4285@localhost.localdomain> <20090111143942.GA28488@unused.rdu.redhat.com> <496A0648.9050100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A0648.9050100@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 08:46:32AM -0600, Eric Sandeen wrote:
> 
> Well, this will now force a filesystem error (then remount-ro or panic
> (or ignore) if the allocation fails.  I'm not sure that's better...?
> 

Well, our choices basically are:

1)  Force a filesystem error
2)  Sleep and retry the allocation
3)  Don't add the freed blocks to the list regions that mballoc should
    be allowed to allocate from after the transaction commits.  This 
    results in the blocks getting "leaked" until the filesystem is
    mounted/unounted.

						- Ted
