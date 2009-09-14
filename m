Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZINVew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZINVew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZINVet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:34:49 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50268 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZINVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QKckk3i1rGYDBdI7ZLx+nlTgzBUdP/JZSkq+S+l99ld3y3qWxSJ4lfaJ2Sgi0Q8A6d
         nLhLoMdRiSXWiVgh9CG25WYvDnqSj6z/6aCB7gPj7lGsrYeJG3ipwVj76dHVZyB+1IU5
         iOMQIyAOmqQFtJPN87QUTQk0QuITgcoe3sbdo=
Message-ID: <4AAEB6F0.4080706@gmail.com>
Date: Mon, 14 Sep 2009 23:34:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.6 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient	msecs_to_jiffies()
 calculation
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
In-Reply-To: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2009 11:07 PM, Andreas Mohr wrote:
> ./drivers/media/video/zc0301/zc0301_core.c
> do
>                             cam->module_param.frame_timeout *
>                             1000 * msecs_to_jiffies(1) );
> multiple times each.
> What they should do instead is
> frame_timeout * msecs_to_jiffies(1000), I'd think.

In fact, msecs_to_jiffies(frame_timeout * 1000) makes much more sense.

> msecs_to_jiffies(1) is quite a bit too boldly assuming
> that all of the msecs_to_jiffies(x) implementation branches
> always round up.

They do, don't they?
