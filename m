Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZKCNu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZKCNu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZKCNu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:50:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZKCNu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:50:27 -0500
Date: Tue, 3 Nov 2009 14:50:22 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Jon Masters <jcm@redhat.com>,
       linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH -rt]
 Updates-from-Jon-Masters-for-hwlat_detector.c.patch
In-Reply-To: <alpine.LFD.2.00.0911031413230.12138@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911031444090.6542@localhost.localdomain>
References: <alpine.LFD.2.00.0910230007030.3737@localhost.localdomain>  <alpine.LFD.2.00.0911021620580.12138@localhost.localdomain> <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com> <alpine.LFD.2.00.0911031413230.12138@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Thomas Gleixner wrote:

> On Mon, 2 Nov 2009, John Kacur wrote:
> > Updated patch just adds the error checking from Jon Masters then,
> > patched against -rt.
> 
> Can you please inline patches ?
> 
> @@ -607,7 +607,11 @@ static ssize_t  debug_enable_fwrite(stru
>  		if (!enabled)
>  			goto unlock;
>  		enabled = 0;
> -		stop_kthread();
> +		err = stop_kthread();
> +		if (0 != err) {
> 
> 	Eeew !	

Yeah, I saw that too and thought it a bit ugly. However, my goal was only 
to make sure that the latest version of Jon's hwlat patch got into -rt, so 
I didn't think it was my place to "fix" his style.

Note - even the much hated checkpatch program doesn't balk at that. 
However that is hardly an authority.

If you read the introduction to "Expert C Programming - Deep C Secrets", 
they mention that some programmers write
if (3==i)
instead of
if (i==3)

because if you mistakenly only type one '=', then the compiler can 
complain about it, instead of silently assigning 3 to i.

I can only guess that is the sort of idea / habit that Jon got that style 
from.

John
