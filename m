Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZHFINj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZHFINj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZHFINi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:13:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZHFINh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:13:37 -0400
Message-ID: <4A7A90AB.3050407@suse.de>
Date: Thu, 06 Aug 2009 17:13:31 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org> <20090805161643.GA28436@kroah.com> <4A79B3A6.7090109@kernel.org> <20090805164919.GA27457@kroah.com> <4A79BB04.8000408@kernel.org> <20090805171547.GB10443@kroah.com> <4A7A6FAE.8020503@kernel.org>
In-Reply-To: <4A7A6FAE.8020503@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Greg KH wrote:
>> Yes the names are confusing, the whole api needs a rework to make it
>> easier to understand :(
> 
> For now, I'll open code it then but it would be really nice to clean
> the names up.

Crap, there's a difference.  For [un]register_chrdev() the chrdev
layer keeps track of cdev while using cdev_alloc/add/del() directly
requires the caller to keep track of the pointer.  Also, it's a bit of
pain to open code the whole thing.

For now, it looks like adding the __ prefixed versions seems to be the
proper solution.  It's strange to provide the helper interface only
for full minor acquisitions anyway.  Let's do naming cleanup later.
How does that sound?

Thanks.

-- 
tejun
