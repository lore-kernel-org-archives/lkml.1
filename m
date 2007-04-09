Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXDILO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXDILO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXDILO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:14:59 -0400
Received: from lazybastard.de ([212.112.238.170]:45353 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXDILO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:14:58 -0400
Date: Mon, 9 Apr 2007 13:09:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070409110927.GA23240@lazybastard.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com> <20070409014426.GA18580@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070409014426.GA18580@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 April 2007 21:44:26 -0400, Theodore Tso wrote:
> 
> Well, Joern thought that rm -rf might relying on the telldir cookie
> being valid in precisely that circumstance.  If that is true, I'd
> argue that this is a BUG in GNU coreutils that should be fixed...

I heard it and accepted that claim without checking it.  Might have been
a mistake.  But the claim came from an NFS developer, which may explain
a thing or two.

NFS clients have to deal with a server rebooting underneith them and
should still behave as expected.  An "rm -r" running on the client
concurrently to a rebooting server is a problem indeed and could be
solved with seekdir/telldir.

That surely doesn't make life any easier for filesystem developers, I
agree.  From that point of view, all telldir cookies should end their
life at closedir time.  For "rm -r" it would be sufficient if the nfs
client simply didn't seekdir at all.  For "ls -lR", this would return
duplicate dentries.

Jörn

-- 
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
