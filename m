Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYH1V1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYH1V1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYH1V1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:27:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYH1V1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:27:46 -0400
Message-ID: <48B7183E.3010100@kernel.org>
Date: Thu, 28 Aug 2008 14:27:26 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: tj@kernel.org, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org> <48B6F7C5.3020204@kernel.org> <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu> <48B708C4.4000405@kernel.org> <E1KYoX9-0004Mn-NX@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYoX9-0004Mn-NX@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 28 Aug 2008, H. Peter Anvin wrote:
>> This is *hard* to get right, and we screw this up in the kernel with 
>> painful regularity.  The throught of having user-space processes, which 
>> don't have access to the kernel locking primitives and functions like 
>> copy_from_user() dealing with this stuff scares me crazy.
> 
> What issues exactly are you thinking of?

Memory changing underneath you.  It can be dealt with by very careful 
sequencing only.

>> That is why I'm suggesting using an in-kernel linearizer.
> 
> Lots of complexity, ugh...  Even Tejun's current scheme is better IMO.

And then you get *no* privilege separation, for one thing, so why even 
bother doing it in userspace?

	-hpa
