Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXDGL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXDGL6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965808AbXDGL6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:58:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1706 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965805AbXDGL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:58:35 -0400
Date: Sat, 7 Apr 2007 13:58:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: compressing intermediate files with LZO on the fly
Message-ID: <20070407115830.GE943@1wt.eu>
References: <200704071432.34157.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071432.34157.a1426z@gawab.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Sat, Apr 07, 2007 at 02:32:34PM +0300, Al Boldi wrote:
> Willy Tarreau wrote:
> >
> > ... for some usages (temporary space),
> > light compression can increase speed. For instance, when processing logs,
> > I get better speed by compressing intermediate files with LZO on the fly.
> 
> How can you do that on ext3?
> 
> Also, can you do that on a partition block-io level?

No, sorry for the confusion. My scripts simply do :

 $ lzop -cd file1.lzo | process | lzop -c3 > file2.lzo

With decent CPU, you can reach higher read/write data rates than what a
single off-the-shelf disk can achieve. For this reason, I think that
reiser4 would be worth trying for this particular usage. And in this case,
I'm not interested at all in reliability. It's just temporary storage. If
the disk fails, I throw it away and buy a new one.

Cheers,
Willy

