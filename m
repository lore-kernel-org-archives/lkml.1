Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXHBXCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXHBXCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXHBXCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:02:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXHBXCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:02:21 -0400
Date: Fri, 3 Aug 2007 00:02:17 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802230217.GR21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 12:36:40AM +0200, Guennadi Liakhovetski wrote:
> On Thu, 2 Aug 2007, Robert Hancock wrote:
> 
> > Because 5 characters will not fit in a 4 character array, even without the
> > null terminator.
> 
> On Fri, 3 Aug 2007, Stefan Richter wrote:
> 
> > How should gcc know whether you actually wanted that char foo[len] to
> > contain a \0 as last element?
> 
> Robert, Stefan, I am sorry, I think, you are VERY wrong here. There is no 
> "even" and no guessing. The "string" DOES include a terminating '\0'.

Read the fucking standard.  In particular, notice that meaning of
string literals outside of initializer is *defined* via that in
initializers.  IOW, string literals contain _nothing_ - not '\0', not
anything else.  The entire reason why use of string literal ends up
with anon array containing \0 is exactly there - it's "how do we
determine the actual length of array of character with unknown length
initialized by string literal".  _That_ is where \0 comes from.

And yes, all quotes you've given are correct.  You are blatantly ignoring
the context even when you are including all relevant parts into the quoted
text.  This stuff hadn't changed since K&R.
