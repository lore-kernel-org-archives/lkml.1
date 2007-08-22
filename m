Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbXHVRun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbXHVRun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXHVRud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:50:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:8686 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761735AbXHVRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aQVwiZlGLD0cFug/kbkD8js5Z8HSY2AarZsnRN7ouzOeWWh7psWeGLIyTaTo/jY0Ch7xnt2igNuE6f5RMp7V+aXGoJlR0P4zq87nWmLDTcjIoXGqlSHn42yKasFf+VfJWPZNqjrQswMWZiDERlhjlYvbwG+5z5wrnXH9T2bt6J8=
Message-ID: <6bffcb0e0708221050s68975158k7a3b27c7c30f455d@mail.gmail.com>
Date: Wed, 22 Aug 2007 19:50:29 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
	 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
	 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
	 <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au>
	 <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 22/08/07, James Morris <jmorris@namei.org> wrote:
[snip]
> > The previous problem is theoretically unrelated.  It arose via a separate
> > mechanism which can't be used at the same as the one you're seeing now in
> > the logs.
> >
> > So this either looks like a problem which has gone unnoticed and was
> > inadvertently fixed at some point, or is unique to the 2.6.20 stable
> > series.
>
> Yup, it is very interesting why no one noticed it. Binary search in progress:
> good - 2.6.20.4
> bad - 2.6.20.8

Ok, I narrowed the problem to 2.6.20.7. There are a few net changes
http://eu.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.7
any suggestions?

I also have seen this avc on 2.6.20.6 during reboot

[ 2333.905944] audit(1187803699.273:271): avc:  denied  { send } for
saddr=192.168.1.70 src=48591 daddr=72.14.217.189 dest=80 netif=eth0
scontext=user_u:system_r:unconfined_t:s0
tcontext=system_u:system_r:kernel_t:s0 tclass=packet
[ 2334.420598] audit(1187803699.789:272): avc:  denied  { send } for
saddr=192.168.1.70 src=47248 daddr=66.249.91.18 dest=80 netif=eth0
scontext=user_u:system_r:unconfined_t:s0
tcontext=system_u:system_r:kernel_t:s0 tclass=packet

so the roots of the problem may lie between 2.6.20.4 and 2.6.20.6

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console2.log

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
