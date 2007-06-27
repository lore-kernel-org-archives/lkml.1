Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbXF0R3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbXF0R3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbXF0R3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:29:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55156 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbXF0R3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:29:09 -0400
Date: Wed, 27 Jun 2007 18:29:03 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627172903.GB21478@ftp.linux.org.uk>
References: <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 09:19:17AM -0700, Linus Torvalds wrote:
> In particular, "offsetof()" should be portably able to basically be the 
> standard #define, which involves an integer cast from a constant pointer. 
> That had *better* be a valid constant integer expression, because it's 
> very useful.

Eh...  I'd say that my variant for offsetof() is simply better - it usually
directly turns into EXPR_VALUE, right in place, without rather convoluted
work.  Aside of "should such cast be a constant integer expression"...
