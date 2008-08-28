Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYH1Toa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYH1Toa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYH1ToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:44:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYH1ToV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:44:21 -0400
Message-ID: <48B6FFB6.7000104@kernel.org>
Date: Thu, 28 Aug 2008 21:42:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 19:44:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> Well, it's only 240 lines with good amount of comments and iovec copying
>> function.  The ioctl itself isn't too complex.  I'm a bit skeptical
>> about direct access.  It can easily introduce security vulnerabilities
>> as there really is no way to hold a pid.
> 
> I don't understand.  No new vulnerabilities are introduced, since it
> would just use existing infrastructure.
> 
> Why is it better if the kernel does the copying of memory regions
> instructed by the userspace filesystem, than if the userspace
> filesystem does that copying itself?  I feel they are totally
> equivalent, except that the latter needs more complexity in the
> kernel.

I'm no security expert but it feels pretty dangerous to me.  First of
all, there are cases where the calling process can exit before the
userland FUSE is finished with an operation, so it might not be always
possible for the FUSE client to tell the PID it got is the correct one.

Another thing is that as it currently stands, the kernel side FUSE
implementation forms a nice safety net taking responsibility of most
security concerns and insulating the mistakes the client may make.
Letting userland client to access and possibly modify the caller's
memory directly weakens that insulation.

Pushing memory access to userland feels a bit too risky to me.  There
seem to be too many loose components in security sensitive path and I
have a nagging feeling that someone will come up with something we can't
think of at the moment.

Thanks.

-- 
tejun
