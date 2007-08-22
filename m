Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXHVNmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXHVNmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbXHVNmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:42:06 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:57428 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755759AbXHVNmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:42:05 -0400
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 22 Aug 2007 09:36:05 -0400
Message-Id: <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 06:23 -0700, James Morris wrote:
> On Wed, 22 Aug 2007, Michal Piotrowski wrote:
> 
> > I got a problem with SELinux
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console.log
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/stable-config
> 
> Please set
> CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=n
> 
> You don't have complete policy for the new network controls, which are not 
> enabled by default and not integreated fully into distros yet.

Still, that denial shouldn't be against kernel_t unless he has iptables
SECMARK rules that assign that value.

It's the change to the skb allocator - no longer clears up through
truesize and thus secmark is garbage initially.  That would apply to
mainline too.

-- 
Stephen Smalley
National Security Agency

