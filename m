Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYH1Sfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYH1Sfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYH1Sfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:39105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYH1Sf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:35:29 -0400
Message-ID: <48B6EF98.4070008@kernel.org>
Date: Thu, 28 Aug 2008 20:34:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:35:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> Hmmm... I was trying to stay within similar operation mechanics as other
>> ops.  Directly accessing the caller's memory has performance benefits
>> but that benefit can also be used by reads and writes.  So, if we're
>> gonna do direct memory access, maybe doing it in more generic way is a
>> better idea?
> 
> On the contrary: playing VM games is going to be slow.  I think this
> approach is best suited for generic ioctl support because it
> simplifies the kernel part.  I'd hate to add all that complexity to
> the kernel if not absolutely necessary.

Well, it's only 240 lines with good amount of comments and iovec copying
function.  The ioctl itself isn't too complex.  I'm a bit skeptical
about direct access.  It can easily introduce security vulnerabilities
as there really is no way to hold a pid.

Thanks.

-- 
tejun
