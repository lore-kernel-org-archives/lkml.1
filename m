Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZJSOBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZJSOBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZJSOBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:01:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbZJSOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KbJ945i7iNMmd45j/GuRosJR0x5H3MDqZ3ZiHudj8V+2m2b+7A1loeSK77NaVr84zh
         ZtnLcllyx7JRVU0bb5VQemDwRc0Su3rwOV0SwLFC+c+r1uoiMSZI33uUaBD/zRnsDa6D
         xFS350+AetiVcChxJLR91fuDgSHMpGwmO1Vew=
Date: Mon, 19 Oct 2009 16:01:45 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tobi Oetiker <tobi@oetiker.ch>, Frans Pop <elendil@planet.nl>,
       Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com
Subject: Re: [Bug #14141] order 2 page allocation failures (generic)
Message-ID: <20091019140145.GA4222@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910190133.33183.elendil@planet.nl> <1255912562.6824.9.camel@penberg-laptop> <200910190444.55867.elendil@planet.nl> <alpine.DEB.2.00.0910191146110.1306@sebohet.brgvxre.pu> <1255946051.5941.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255946051.5941.2.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 12:54:11PM +0300, Pekka Enberg wrote:
> On Mon, 2009-10-19 at 11:49 +0200, Tobi Oetiker wrote:
> > I have updated a fileserver to 2.6.31 today and I see page
> > allocation failures from several parts of the system ... mostly nfs though ... (it is a nfs server).
> > So I guess the problem must be quite generic:
> 
> Yup, it almost certainly is. Does this patch help?
> 
> http://lkml.org/lkml/2009/10/16/89

This patch seems to help in some cases.  Before applying this patch I
was able to trigger alloc failures on different machine by booting
kernel with "mem=256MB" and doing:

  $ gitk on-full-tree &
  # rmmod e100
  ... wait for few MBs in swap
  # modprobe e100; ifup --force ethX

So here this patch helped -- with it, I was unable to trigger page
allocation failures (testing was short, tough).  However, as I said
here[1], I applied both of Mel's patches (including this one) and that
didn't help my orginal issue (failures after suspend).

[1] http://lkml.org/lkml/2009/10/17/109

Thanks.
