Return-Path: <linux-kernel-owner+w=401wt.eu-S937260AbXGTBqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937260AbXGTBqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbXGTBqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:46:42 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:2072 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbXGTBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zs+Xc9J8hmO+RCmLbrzXgi5H1pPG4hT6+MF1vdgyInCKTgl5rcOunZ1H6a37DHsuVqtG2W7BKywrho+6Zz5BdTOxNVcWLbsqJQUM/SN/n+9iOzk3/ANteEfrdBShMAHceDSjOTU0ubI1aFkWOkPc08C/j5jkhRuiBn/IiR+lC6k=
Message-ID: <91b13c310707191846qc981c5bhbbac01502a7c8d95@mail.gmail.com>
Date: Fri, 20 Jul 2007 09:46:38 +0800
From: "rae l" <crquan@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: [PATCH 2/2] nbd: change a parameter's type to remove a memcpy call
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Steven Whitehouse" <steve@chygwyn.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, debra <chdebra@gmail.com>
In-Reply-To: <469FA0F9.9090001@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11848376711601-git-send-email-crquan@gmail.com>
	 <11848377013773-git-send-email-crquan@gmail.com>
	 <469FA0F9.9090001@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Paul Clements <paul.clements@steeleye.com> wrote:
> Denis Cheng wrote:
> > this memcpy looks so strange, in fact it's merely a pointer dereference,
> > so I change the parameter's type to refer it more directly,
> > this could make the memcpy not needed anymore.
> >
> > in the function nbd_read_stat where nbd_find_request is only once called,
> > the parameter served should be transformed accordingly.
>
> This is really a matter of preference. The generated code ends up being
> about the same, I think, while your patch makes the call to
> nbd_find_request kind of obtuse. Also, the memcpy's are balanced between
> send_req and find_request, so you can quickly see how the data is being
> transferred (from req into handle, and then back again). Your patch
> makes this less clear, at least to me.
With one explicit memcpy stripped out, I think it's more clear to
nbd_find_request.
In nbd_read_stat, the cast to (struct request **) is not apparent, I
must admit; but I think the best solution is declaring other few
structs to make it clear, it's due to the lack of description of nbd
client and server communication protocol.

BTW, I think the nbd driver needs a clear documentation (its main site
http://nbd.sourceforge.net/ does not give it):

1. When nbd_find_request is needed to call, the 8 byte memory of char
handle[8] field in struct nbd_reply actually stores a pointer (struct
request *), that pointer is received from the network. Since a pointer
is only meaningful to the host, transfering it over the network will
be unreliable, I don't think it's a good design,

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
