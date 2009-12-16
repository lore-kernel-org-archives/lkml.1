Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbZLPXO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbZLPXO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763362AbZLPXO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:14:58 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:35045 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988AbZLPXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:14:56 -0500
Date: Wed, 16 Dec 2009 21:14:51 -0200
From: cascardo@holoscopio.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rubini@gnudd.com
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091216231451.GC7791@holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
 <4AF8B4FF.9050405@zytor.com>
 <20091111153632.944a255c.akpm@linux-foundation.org>
 <20091215143446.8b6a7e57.akpm@linux-foundation.org>
 <4B2810D6.9030309@zytor.com>
 <20091215225630.GA12918@suse.de>
 <20091215235639.25e841f1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215235639.25e841f1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:56:39PM +0000, Alan Cox wrote:
> What I have been doing in response to requests for misc device
> allocations is to suggest people simply go and allocate some dynamic
> device space. There are very very few cases a misc device needs a
> specific minor and the large dynamic device space has really made misc a
> "historical" entity which should be treated that way.
> 
> If you want 2048 minors for a random new device, the kernel will just
> magic them for you, udev will magic the device nodes, and the tmpfs will
> handle it nicely
> 
> (and if your udev isn't on its own private file system then I hope its an
> old one, because the current one has a hole in it, which doesn't seem to
> have been fixed yet)
> 
> Alan

I have one "issue" to raise about using anything else: misc devices are
easy to register: they have a class of its own, you don't need to
allocate a range and, then, create the device with its respective file
operations and all that. For one-shot devices, they are really a good
thing.

Does it make sense to create an easier and simpler API for creating
character devices that does not allocate a major with minor 0 and 255
minors which also creates your own class?

I think many device driver writers go for proc filesystem these days
because you just have to call a function with your file name and file
operations and that's it. Most of these people are damn lazy people, I
would agree. But, perhaps, we should make it easier for these lazy
people to write better interfaces. Or perhaps this would spoil them and
they would not do their homework and use the right interface anyway.

I've seen code that should have been using the input subsystem and was
using proc files. And that's why I'm saying they could be spoiled with
such an easy interface. They would still use the wrong interface anyway,
with character devices instead of using the input subsystem.

Well, I'll have a go for such an interface and request comments. It
would not be much different from the misc system anyway, but would allow
more than one device, any (dynamic) major to be used, and a class name
for each registerer.

Regards,
Cascardo.
