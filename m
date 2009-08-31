Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZHaMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZHaMCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZHaMCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:02:50 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:61258 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbZHaMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:02:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOJYm0pR9dii/2dsb2JhbADWMwmEEQWCRA
Date: Mon, 31 Aug 2009 14:02:50 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: roel.kluin@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, teheo@suse.de
Subject: Re: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after
	errors
Message-ID: <20090831120250.GM29382@infomag.iguana.be>
References: <4A93ACDA.8030000@gmail.com> <20090827.235200.21363768.anemo@mba.ocn.ne.jp> <20090827201317.GH29382@infomag.iguana.be> <20090828.232429.106266868.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828.232429.106266868.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atsushi,

> On Thu, 27 Aug 2009 22:13:17 +0200, Wim Van Sebroeck <wim@iguana.be> wrote:
> > > > Make txx9wdt_probe() clean up after errors.
> > > > 
> > > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > > ---
> > > > Any comments?
> > > 
> > > Well, why is this patch needed?  I intentionally omitted iounmap and
> > > release_mem_region because devres guarantee these resources are freed
> > > on probe failure.  Or are there any leaks?
> > 
> > My opinion: a driver should do proper clean-up on probe failures because
> > 1) this makes clean and robust code and shows that you know what you are doing
> > 2) to avoid having to search for leaks if there are any. See the NULL pointer story...
> 
> I think "proper clean-up" in this case is "do nothing for
> devres-managed resources".  An example in
> Documentation/driver-model/devres.txt clearly say so.  Actually most
> drivers do not call devm_iounmap in any case.

I will have a look at devres managed resources and than come back on this.

> Also, the patch added devm_iounmap in failure path but not in exit
> path.  This looks inconsistent.

Correct, if we use it in the probe error function then it should be used also in the exit function.

Kind regards,
Wim.

