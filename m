Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZLaDMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZLaDMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZLaDMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:12:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZLaDMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:12:22 -0500
Message-ID: <4B3C1619.7060001@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 11:10:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf: confused by cc1
References: <20091231014714.GA8313@gallifrey>
In-Reply-To: <20091231014714.GA8313@gallifrey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dr. David Alan Gilbert wrote:
> Hi,
>   I'm running 2.6.33rc2 and thought I'd have a play with perf; its
> symbol resolution code seems to be getting itself a bit confused however:
> 
> I recorded a trace of a kernel build like so:
> 
>  sudo /discs/more/git/linux-2.6/tools/perf/perf record -a -e cycles -i -g -v -s -d make -j 8 bzImage
> 
> Then I did:
> /discs/more/git/linux-2.6/tools/perf/perf report -g
> 
> and the top entry is:
> 
>     69.89%              cc1  cc1                                                      [.] 0x000000000337cd
>                         |          
>                         |--0.99%-- 0x9f5da8
>                         |          
>                         |--0.74%-- 0x9eec95
>                          --98.27%-- [...]
> 
> but it's refusing to do symbol look up for cc1 even if I install
> the (ubuntu) debug packages (most other files it is doing
> symbol resolution on where they have it). I dug a bit further and
> it looks like it's not trying to look up the debug packages for cc1
> because it think that mapping is a kernel map.  Also for some reason it
> thinks the cc1 is an overlapping mapping with the gcc4 binary it's been
> executed from:
> 

Your kernel is relocatable? See: http://lkml.org/lkml/2009/12/29/358

Thanks,
Xiao
