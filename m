Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZGXKzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZGXKzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZGXKzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:55:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZGXKzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:55:35 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/5] drivers/isdn: Drop unnecessary NULL test
Date: Fri, 24 Jul 2009 12:55:32 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0907122204140.22658@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907122204140.22658@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907241255.33013.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX1+lz0QOQEJJKNJ2fVEVQZxr39FEiOO2KW4qknt
 Ff1AJsY+E9FvDQyhV2XIhes5GiWPuWiCf6m5iTBzxIVso1krG+
 qEVeknQOY84yKRB679IKkrNjzO5BdxB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACK, thanks for spotting this.

I will include this in my next patchset.

Karsten

On Sonntag, 12. Juli 2009 22:05:03 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The result of container_of should not be NULL.  In particular, in this case
> the argument to the enclosing function has passed though INIT_WORK, which
> dereferences it, implying that its container cannot be NULL.
>
> A simplified version of the semantic patch that makes this change is as
> follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> identifier fn,work,x,fld;
> type T;
> expression E1,E2;
> statement S;
> @@
>
> static fn(struct work_struct *work) {
>   ... when != work = E1
>   x = container_of(work,T,fld)
>   ... when != x = E2
> - if (x == NULL) S
>   ...
> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/isdn/hisax/amd7930_fn.c |    2 --
>  drivers/isdn/hisax/hfc_pci.c    |    2 --
>  drivers/isdn/hisax/hfc_sx.c     |    2 --
>  drivers/isdn/hisax/icc.c        |    2 --
>  drivers/isdn/hisax/isac.c       |    2 --
>  drivers/isdn/hisax/w6692.c      |    2 --
>  6 files changed, 12 deletions(-)
...

