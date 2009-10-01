Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZJAAb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZJAAb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZJAAb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:31:27 -0400
Received: from borg.medozas.de ([188.40.89.202]:39003 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbZJAAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:31:25 -0400
Date: Thu, 1 Oct 2009 02:31:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Joe Perches <joe@perches.com>
cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
       netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/netfilter/ipvs: Move #define KMSG_COMPONENT to
 Makefile
In-Reply-To: <1254352160.2960.119.camel@Joe-Laptop.home>
Message-ID: <alpine.LSU.2.00.0910010219100.7559@obet.zrqbmnf.qr>
References: <cover.1254349374.git.joe@perches.com>  <0026bcf5aad9ae5036e68fc2dcda9c778d30dc47.1254349375.git.joe@perches.com>  <alpine.LSU.2.00.0910010042540.782@obet.zrqbmnf.qr> <1254352160.2960.119.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-10-01 01:09, Joe Perches wrote:
>On Thu, 2009-10-01 at 00:46 +0200, Jan Engelhardt wrote:
>> On Thursday 2009-10-01 00:37, Joe Perches wrote:
>> >This centralizes the definition and removes the
>> >replicated #defines from all files
>
>I think this increased command line length hardly matters.
>
>I think a reasonable complaint might be that it separates
>the definition of a macro from the code.  I think it's
>similar to the already used KBUILD_MODNAME macro though.

KBUILD_MODNAME is special in that it is derived from the actual
source filename. Of course you could put #define KBUILD_MODNAME "foo"
in your source file, but that is like putting changelogs there
when they belong into the git log.

>> How about an #include file for the ipvs private things?
>
>It's not just IPVS, this style could be used treewide
>without requiring extra #includes.

Well I personally prefer the #include instead of hiding such in 
Makefiles. You know, when newcomers could start doing `grep 
KMSG_COMPONENT *.[ch]`. Perhaps GCC's -include flag in a Makefile
to avoid #includes in .c files?
