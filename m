Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYKQRMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYKQRMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYKQRME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:12:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:25723 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYKQRMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:12:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R5yI5HzNKsqvUvOIkcNpy7z5txeJzLNaomQocBSP3fI6y/n0AUzrOcaAcfgx/RtjGS
         zLU55xOJkmn+zHiapyueEzwDR+/rx3+FADPxyWQurUfVKjSVIUI4Wv6FqZWyRwEgr37l
         7rhK0kq8L9wkXjoLf8pXz+Aa98AcXBuMqVg0Y=
Date: Mon, 17 Nov 2008 20:11:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081117171157.GB7326@localhost>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117165224.GH12081@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Nov 17, 2008 at 05:52:24PM +0100]
| 
| * Yinghai Lu <yinghai@kernel.org> wrote:
| 
| > Impact: fix wakeup path with numaq and es7000
| 
| applied	to tip/x86/quirks, thanks Yinghai!
| 
| A couple of comments:
| 
| > +static inline void inquire_remote_apic(int apicid)
| > +{
| > +	if (apic_verbosity >= APIC_DEBUG)
| > +		__inquire_remote_apic(apicid);
| > +}
|

Btw, Ingo, Yinghai,

it's a bit weird but I found that we use apic_verbosity
here to _do_ something (ie touching circuit) but on any
other cases apic_verbosity is just a additional logging
filter so -- what the initial apic_verbosity purpose was?
If it's just a logging filter (to which I'm more biased)
this case is plain wrong. But if apic_verbosity is not
like this -- then it's fine. Since I was not initial author
of the code -- I'm asking you :)

		- Cyrill -
