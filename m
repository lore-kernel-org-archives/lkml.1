Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbXBMGLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbXBMGLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXBMGLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:11:40 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:44132 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751123AbXBMGLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:11:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FVefIeVvfEfVImTpB83+sMCBVM0Ihhli/TK249aRDbIRJHTxynUCtEA6Hlrx+11dNPYNlKiH8hJdnAKmFs+J/6LoK2ukZr+EqD4d/m5edDyx73V0P81HiRm8cmabGxylTVt10G+m623oRqVw22y1xbsG3sw1P8ibtQY2P4GPL1I=  ;
X-YMail-OSG: qJt11s8VM1mlDWLPvBNuzgYzZk6ycgij11IHDVBnP4s85EuwkX22PLDPgRESPhYKJbEzOMjt87HkgqjdyXCfGAbq7a9gK8Fs.HjRC8wzaF49JerZtsvciPCuez4nx0XVrxcaCVhbuJf8Eug-
Message-ID: <45D15687.5080505@yahoo.com.au>
Date: Tue, 13 Feb 2007 17:11:19 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       Norman Weathers <norman.r.weathers@conocophillips.com>,
       "Vladimir V \".\" Saveliev" <vs@namesys.com>
Subject: Re: [PATCH] knfsd: Stop NFSD writes from being broken into lots of
 little writes to filesystem.
References: <20070213170049.3488.patches@notabene> <1070213060131.3560@suse.de>
In-Reply-To: <1070213060131.3560@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> Another nfsd patch for 2.6.21...
> 
> ### Comments for Changeset
> 
> When NFSD receives a write request, the data is typically in a number
> of 1448 byte segments and writev is used to collect them together.
> 
> Unfortunately, generic_file_buffered_write passes these to the filesystem
> one at a time, so an e.g. 32K over-write becomes a series of partial-page
> writes to each page, causing the filesystem to have to pre-read those
> pages - wasted effort.
> 
> generic_file_buffered_write handles one segment of the vector at a
> time as it has to pre-fault in each segment to avoid deadlocks.  When
> writing from kernel-space (and nfsd does) this is not an issue, so
> generic_file_buffered_write does not need to break and iovec from nfsd
> into little pieces.
> 
> This patch avoids the splitting when  get_fs is KERNEL_DS as it is
> from NFSd.
> 
> This issue was introduced by commit 6527c2bdf1f833cc18e8f42bd97973d583e4aa83
> 
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>

FWIW, you can put Acked-by: me there if you'd like.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
