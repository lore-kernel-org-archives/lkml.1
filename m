Return-Path: <linux-kernel-owner+w=401wt.eu-S1765058AbXILVq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765058AbXILVq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXILVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:46:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXILVqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:46:48 -0400
Message-ID: <46E85E41.5000403@zytor.com>
Date: Wed, 12 Sep 2007 14:46:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Brent Casavant <bcasavan@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
References: <20070912144128.D5573@pkunk.americas.sgi.com> <46E85528.3010405@zytor.com> <20070912163645.E5573@pkunk.americas.sgi.com>
In-Reply-To: <20070912163645.E5573@pkunk.americas.sgi.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant wrote:
> On Wed, 12 Sep 2007, H. Peter Anvin wrote:
> 
>> Brent Casavant wrote:
> 
>>> 	http://marc.info/?l=linux-kernel&m=93032806224160&w=2
>> This link talks about file flags handling.  I don't see the relevance to
>> this problem at all.  However, this is a very long thread, so if there
>> is anything specific that you want to point to, then please elucidate.
> 
> Oops, my mistake -- I pasted the wrong URL.  I meant this thread, this
> post in particular:
> 
> 	http://marc.info/?l=linux-kernel&m=88937224115435&w=2
> 
> Still, O_NOLINK would seem to be a valuable addition, and greatly
> simplify secure temporary file creation.
> 

Avoiding -- or at least detecting -- symlink racing with mkdir() is
relatively simple: run mkdir(), make sure you don't get EEXIST or
something like that, lstat() the resulting path -- it should be a
directory with all the right modes and ownerships.

I believe -- but I'm not certain -- that mkdtemp() in glibc will do all
this for you.  If not, I would consider that a glibc bug.

	-hpa
