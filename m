Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYHTAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYHTAMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYHTAML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:12:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYHTAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:12:10 -0400
Date: Tue, 19 Aug 2008 17:11:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Trojanowski <bart@jukie.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
In-Reply-To: <20080820000339.GB28029@jukie.net>
Message-ID: <alpine.LFD.1.10.0808191709130.3324@nehalem.linux-foundation.org>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org> <20080820000339.GB28029@jukie.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Bart Trojanowski wrote:
> 
> Ok, I will test your patch and let you know in a few minutes.

Btw, while you're at it, can you try doing some random writes to that 
thing, since the whole sync mount is quite possibly going to find a few 
other cases like this. 

IOW, _maybe_ you hit the only case that is ever going to be an issue for 
sync mounts, and maybe you didn't. In my eternal quest to never actually 
test anything myself, I'm hoping you can try some writing (and 
over-writing) of files, since writes to the filesystem is where the whole 
"sync" thing is going to show up (both metadata ie file creation and 
removal, and "real" data ie normal write/truncate calls).

			Linus
