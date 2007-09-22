Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXIVJfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXIVJfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXIVJfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:35:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:51090 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbXIVJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WLyD9utmOEAlKsyeE/VseyNIfJxrBGE1ZJJNpc7kaX6ASucJ9jGY0PaExSzpW4waND/vx2Uw4KWuhDuXwAuLh9YK0/d51ZoKd+wsk9K6O+FzzrdLiue/HI4vgigxjrW3McbY2YAOWAc3u+0aamyM67XM8xbhg7AEZV7zvDzkxYo=
Date: Sat, 22 Sep 2007 13:35:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
Message-ID: <20070922093507.GB7226@cvg>
References: <20070922083355.GA7226@cvg> <Pine.LNX.4.64.0709220441090.21302@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709220441090.21302@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Sat, Sep 22, 2007 at 04:48:28AM -0400]
| On Sat, 22 Sep 2007, Cyrill Gorcunov wrote:
| 
| > Hi list,
| >
| > could anyone tell me why there is no official memzero function (or
| > macros) in the kernel. As I see a lot of kernel parts calls for it
| > (defying own macros as alias to memset). Maybe there is a special
| > reason not to do so? Actually my suggestion is to define _one_
| > general macros for this.
| 
| i brought up this issue on the KJ list once upon a time:
| 
| https://lists.linux-foundation.org/pipermail/kernel-janitors/2007-February/017847.html
| 
| and there didn't seem to be much enthusiasm for it.
| 
|   however, i am still curious why there isn't more use of the
| already-defined "clear_page" macro.  most architectures appear to
| define it:
| 
| $ grep -r "define.*clear_page" include
| 
| but there are still numerous explicit calls to memset() to zero a
| chunk of memory that is exactly PAGE_SIZE in size.  just an
| observation.
| 
| rday
| -- 
| ========================================================================
| Robert P. J. Day
| Linux Consulting, Training and Annoying Kernel Pedantry
| Waterloo, Ontario, CANADA
| 
| http://crashcourse.ca
| ========================================================================
| 

Thanks Robert for the answer, I'll mark this (clear_page) in my "must to
take a look" list ;)
Well if there is no strong reason of keeping this separate '#define memzero'
I think it's a good case to merge them in some _single_ #define ;)

Waiting for other comments...

P.S.
In a mail you pointed to said that memset(...,0,...) is quite clear -
yes it's quite clear indeed but we already _have_ a lot of '#define memzero'
and who knows or may give the guarantee that new '#define memzero '_will not_'
appear in the kernel.

		Cyrill

