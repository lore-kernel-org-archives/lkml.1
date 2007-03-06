Return-Path: <linux-kernel-owner+w=401wt.eu-S965323AbXCFQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323AbXCFQmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965336AbXCFQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:42:43 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:32175 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965323AbXCFQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=JqBKTOLyYDw1VxzIrvXkCDd0ysq7UAqysZLScPS5ua8BKievUtBdLPfM8zClZgiat4w1ryqxUBwlWwG7+UnQ/M/oHiNod5kC0gtpygkR3aY/Aj+23khj2/caguOsqVLVfch1ks0NVgEON7cQOWa/dmnk6Dc4RgTdA1D2HCBS+vs=
From: Eric Lacombe <tuxiko@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Date: Tue, 6 Mar 2007 17:42:36 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <200703052219.23439.tuxiko@free.fr> <20070305221640.GA25369@electric-eye.fr.zoreil.com>
In-Reply-To: <20070305221640.GA25369@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061742.36467.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just triggered the bug again but _now_ without the nvidia proprietary 
module. Unfortunately, I hadn't enable the DEBUG options yet.

Nevertheless, It seems that the bug was triggered when the NAS was going to 
awake and that 2 user applications wanted to access it during his awakening.

Maybe it could give you some clues about where the problem could be (it seems 
to be a deadlock that occur when (maybe) the r8169 driver is waiting to serve 
one application and that an other one reclaim the same type of service, 
dunno...).

I will give you more information and a trace if I can obtain it.

Thanks

	Eric Lacombe


On Monday 05 March 2007 23:16:40 Francois Romieu wrote:
> Eric Lacombe <tuxiko@free.fr> :
> [...]
>
> > Also, if you have some new ideas about the problem or what I could try to
> > trigger it more frequently (I already wake up the NAS as more as I can,
> > but maybe I could write a script to do that), I would be thankful.
>
> You can add more DEBUG options for spinlock and stack usage, disable
> preempt and pray for a trace before the crash. If you do not have a
> second host to add more traffic (wrt to bandwidth and/or pps), try to
> dd your disk and/or your remote storage to /dev/null while watching TV.
>
> You are out of luck if it does not crash more easily.


