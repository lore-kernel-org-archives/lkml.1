Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZIBNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZIBNLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZIBNLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:11:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:35937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZIBNLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:11:33 -0400
Date: Wed, 2 Sep 2009 06:14:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>, tj@elte.hu
Subject: Re: [PATCH, v2] isdn: Fix stack corruption in isdnloop_init()
Message-ID: <20090902061439.6c60124c@infradead.org>
In-Reply-To: <20090902130336.GA16906@elte.hu>
References: <20090902124402.GA5539@elte.hu>
	<20090902130336.GA16906@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009 15:03:36 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> [ v2: use strlen instead of sizeof. ]
> 
> diff --git a/drivers/isdn/isdnloop/isdnloop.c
> b/drivers/isdn/isdnloop/isdnloop.c index a335c85..0c8d8cb 100644
> --- a/drivers/isdn/isdnloop/isdnloop.c
> +++ b/drivers/isdn/isdnloop/isdnloop.c
> @@ -1494,7 +1494,7 @@ static int __init
>  isdnloop_init(void)
>  {
>  	char *p;
> -	char rev[10];
> +	char rev[strlen(revision)+1];
>  
>  	if ((p = strchr(revision, ':'))) {
>  		strcpy(rev, p + 1);

now it;s a runtime variable sized array.
NotNice(tm)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
