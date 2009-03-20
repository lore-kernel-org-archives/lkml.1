Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZCTUgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZCTUgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZCTUgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:36:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:12118 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZCTUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F7VH5Y4Pkd9sjikAIIYHt7R30vuy1T/KlaLgM+/JEAk0ubHW+dQ9a6uQfmqxS4p/nR
         fEQPIAUwymj+Jvz7I8pj0/vKMPEdfs3odbYUkub0IsihsqdeD3A3TvHmFlVo1a6p9ld4
         xuJQZ7tYmb+2JIADc3E5GjaNDekjk8BFV9sWo=
Date: Fri, 20 Mar 2009 23:36:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Bartlett <ajb.stxsl@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix IO APIC resource allocation error message
Message-ID: <20090320203653.GI7453@localhost>
References: <200903202012.41344.bzolnier@gmail.com> <200903202102.28585.bzolnier@gmail.com> <20090320200954.GH7453@localhost> <200903202127.16307.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903202127.16307.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Bartlomiej Zolnierkiewicz - Fri, Mar 20, 2009 at 09:27:14PM +0100]
...
| > | > Now we would have 'err' here and get out only on conflicting resource.
| > | > Did I miss something?
| > | 
| > | nr_ioapics > 0 && r == NULL ?
| > | 
| > 
| > This case happens when alloc_bootmem fails but we already panic'ed!
| > 
| > Here is what I mean
| > 
| > From ioapic_setup_resources()
| > 
| > 	if (nr_ioapics <= 0)
| > 		return NULL;
| > 
| > 	mem = alloc_bootmem(n); <- we panic here anyway
| 
| Seems like the following check is superfluous then:
| 
|         if (mem != NULL) {

Yes I believe

| 
| > 	...
| > 	ioapic_resources = res;
| 
| In either case I don't think we that failing all resource insertions
| (for all IO APICs) if only one has failed is a desirable behavior...

Indeed, which is even better

| 
| Thanks,
| Bart
| 

Your patch is already merged, so all is fine -- sorry for noise.

	- Cyrill -
