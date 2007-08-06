Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXHFHoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXHFHoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXHFHn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:43:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:36899 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXHFHnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mp3Z/TWILJQvFVv4M573UqEpg1DJL4E7HRgU1ISdmHVO1cpjTOZ8ptXrzB/0DwdAi+kI2I5MbxKkV6Kc4wPj/UXQ8apKMJMIMur+VdXPAiVI7mrexZ5mmt2ndmwunUnqH/nltVnzZosRu9jjyHKNgzPmxCIiuWwwPwK4cuCiuEA=
Message-ID: <8734b7880708060043i125419e0w3db5d4431496985f@mail.gmail.com>
Date: Mon, 6 Aug 2007 17:43:54 +1000
From: "Lindsay Roberts" <lindsay.roberts.os@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] fs: Add romfs version 2
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
In-Reply-To: <20070725184005.GD8225@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
	 <20070717013635.d6d0b124.akpm@linux-foundation.org>
	 <20070717192100.GE11166@waste.org>
	 <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
	 <20070725184005.GD8225@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Pavel Machek <pavel@ucw.cz> wrote:
> If the fs is read-only.. can we do some tail packing and get _both_
> speed and space efficiency?

You mean don't block align files of size less than 1k, and
intelligently pack them into the gaps left by files that are aligned?
Does seem that most noticeable performance issues occur on sequential
reads of large files, this sounds like a good idea, but I would
welcome comments on this.

Also I assume romfs currently has a small hidden benefit as a result
of it storing its file data serially after the inode: the initial read
of the inode reads and therefore caches the block containing the
(initial) file data. Obviously with block aligned file data this only
applies if sequential prefetching is performed. I'd be interested to
know if this is an issue worth regarding.

-- Lindsay
