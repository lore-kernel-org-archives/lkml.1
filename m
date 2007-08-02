Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXHBKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXHBKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXHBKNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:13:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:63049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXHBKNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NPAJWtxUptu4YiJ/i7JusIREFtMHAK2wOfcWArFw4GubbuDoIWHntvu0NPBbOvVpsRa3otmLoVZRSFRNbB6efBu32wYT3NAhr30uO12xluytB02QlEVMGGsePLXEDYxjXROfYmZpUXydYGro/rvhFmhpVxyHzdjj56hYFZqlHM0=
Message-ID: <1158166a0708020313r22201c3bm722ec5bb050e609b@mail.gmail.com>
Date: Thu, 2 Aug 2007 11:13:15 +0100
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070802042528.GA5797@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
	 <20070801053509.GA5905@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
	 <20070802042528.GA5797@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > Please, copy strtonum() from BSD instead. Nobody needs another
> > > home-grown converter.
> >
> > BSD's strtonum(3) is a detestful, horrible shame.
> >
> > The strtol_check_range() I implemented here does _all_ that strtonum()
> > does, plus is generic w.r.t. base,
>
> What you did with base argument is creating opportunity to fsckup,
> namely, forgetting that base is last and putting it second.

Embedding base in function name (func10, func8, func16 [, func2])
will eliminate that possibility and also save one argument
push on stack.

You can always multiplex them locally:

static int func_generic(base...) {...}

int func10(...) { return func_generic(10, ....); }
int func8(...) { return func_generic(8, ....); }

You also can have a faster "static int func_power_of_2(base...)" for
2,8,16, etc.
--
vda
