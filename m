Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZJUS0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZJUS0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZJUS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:26:22 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9747 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZJUS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:26:21 -0400
Message-ID: <4ADF5225.40701@caviumnetworks.com>
Date: Wed, 21 Oct 2009 11:25:41 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>	 <4ADF38D5.9060100@caviumnetworks.com>	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>	 <4ADF3FE0.5090104@caviumnetworks.com>	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>	 <4ADF4982.9010306@caviumnetworks.com> <1256148562.18347.3264.camel@gandalf.stny.rr.com>
In-Reply-To: <1256148562.18347.3264.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2009 18:25:42.0038 (UTC) FILETIME=[E59FA360:01CA527B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
[...]
> We're not doing back traces. We need to modify the return of the
> function being called. Note, the above functions that end with ";" are
> leaf functions. Non leaf functions show "{" and end with "}".
> 
> The trick here is to find a reliable way to modify the return address.
> 

Well that's what I get for chiming in without fully understanding the 
context.

I think it is fine to search backwards from the ($ra - 8) of the call to 
_mcount until you encounter the adjustment of $sp.  If you encounter a 
store of $ra, you can assume that the function will use the stored value 
when returning, otherwise modify the value restored to $ra (passed in 
$at).  That is probably what you were doing to begin with.

David Daney
