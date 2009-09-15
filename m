Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZIOTVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZIOTVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbZIOTVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:21:44 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60147 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397AbZIOTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:21:43 -0400
Date: Tue, 15 Sep 2009 21:21:46 +0200
From: Andreas Mohr <andi@lisas.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
Subject: Re: V4L2 drivers: potentially dangerous and inefficient
	msecs_to_jiffies() calculation
Message-ID: <20090915192146.GA18002@rhlx01.hs-esslingen.de>
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de> <4AAFE78B.6060606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAFE78B.6060606@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 15, 2009 at 09:14:19PM +0200, Marcin Slusarz wrote:
> Andreas Mohr pisze:
> > ./drivers/media/video/zc0301/zc0301_core.c
> > do
> >                             cam->module_param.frame_timeout *
> >                             1000 * msecs_to_jiffies(1) );
> > multiple times each.
> > What they should do instead is
> > frame_timeout * msecs_to_jiffies(1000), I'd think.
> 
> Or better: frame_timeout * HZ

D'oh! ;-)

But then what about the other 3 bazillion places in the kernel
doing multiples of seconds?

linux-2.6.31]$ find . -name "*.c"|xargs grep msecs_to_jiffies|grep 1000|wc -l
73

If this expression is really better (also/especially from a maintenance POV),
then it should get changed.

> Marcin

Andreas Mohr
