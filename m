Return-Path: <linux-kernel-owner+w=401wt.eu-S965109AbXDJMMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbXDJMMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXDJMMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:12:32 -0400
Received: from lazybastard.de ([212.112.238.170]:36259 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXDJMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:12:31 -0400
Date: Tue, 10 Apr 2007 14:08:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070410120825.GA29487@lazybastard.org>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <20070410072253.GA28665@lazybastard.org> <20070410112718.GF13650@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070410112718.GF13650@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 April 2007 07:27:18 -0400, Theodore Tso wrote:
> 
> I suppose what you could do is to read in the journal, and use it to
> create an remapping table so that when you want to read block #5126,
> and block number 5126 is in the journal, to read the journal version
> of the block instead of the one on disk.  That would allow for safe
> access to a filesystem being mounted read-only without the journal
> being present.

Another option would be to access the medium through a mapping inode,
replay the journal into the mapping inode and _not_ flush the dirty
pages.  But as long as a remapping table is sufficient for ext3 journal
format, such a table should be simpler and faster.

> Patches gratefully accepted....

Not likely to come from me anytime soon.  There's a certain other
filesystem I have to finish first that still suffers from the same
problem.

Jörn

-- 
Do not stop an army on its way home.
-- Sun Tzu
