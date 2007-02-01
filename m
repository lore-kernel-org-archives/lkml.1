Return-Path: <linux-kernel-owner+w=401wt.eu-S1161197AbXBAGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbXBAGAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161193AbXBAGAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:00:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161197AbXBAGAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:00:43 -0500
Date: Wed, 31 Jan 2007 22:00:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: =?ISO-8859-1?Q?S=2E=C3a=C4lar_Onur?= <caglar@pardus.org.tr>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Mark Huang <mlhuang@CS.Princeton.EDU>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <45C17E4C.1030509@zytor.com>
Message-ID: <Pine.LNX.4.64.0701312157450.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org>
 <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
 <45C17E4C.1030509@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Jan 2007, H. Peter Anvin wrote:
> 
> It would be interesting to know what the inode numbers are in the image; also,
> what is the exact behaviour -- do you end up with a missing link, or do both
> entries end up getting hard-linked to an empty file?

Judging by the

	request_module: runaway loop modprobe binfmt-0000

one or more of the hardlinked binaries (modprobe being one, but not 
necessarily the one that initially triggers hits) will read all zeroes-

Or at least bytes at offsets 2 and 3 will read as zero, causing it to not 
be recognized as a proper binary, causing that "binfmt-0000" thing.

			Linus
