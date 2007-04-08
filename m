Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXDHT3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXDHT3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXDHT3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:29:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXDHT3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:29:31 -0400
Message-ID: <46194260.3050900@zytor.com>
Date: Sun, 08 Apr 2007 12:28:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org>
In-Reply-To: <20070408191955.GD29180@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> It doesn't state explicitly that you can use the telldir cookie()
> after closing the directory stream using closedir() and then reopening
> it using opendir(), but given that it states that results are
> undefined after a rewinddir() --- which is much less violent than a
> closedir()/opendir(), I would definitely argue that an application
> programmer would be very ill-advised to rely on this working.
> 
> (Of course, I'd argue that an application programmer shouldn't use
> telldir/seekdir at all.....)
> 
> Ulrich, is it too late to insert a clarification that the telldir()
> cookie isn't guaranteed to be valid after closedir() *or* rewinddir()?

More fundamentally, the telldir cookie should never be valid when 
applied to a different DIR * (even one that refers to the same directory.)

	-hpa
