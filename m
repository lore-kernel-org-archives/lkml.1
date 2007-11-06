Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbXKFXwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbXKFXwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXKFXwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:52:25 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:41146 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753717AbXKFXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:52:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jdfA85Xhc4YLO4Bo+WxkcHe3uTQX2NpyHQTxNIvunybxddq6bQFFQWXqjxLfb/VzwCeplH4hemr8uyJ9yPZthnOzyySQQO9+kJ0pNfM1IDkZmnnWL8XrZJ5YfnpInWCKnrTl2LdWG+rF8ESi/DAaP0DXsrALToX9ycxy9o413Nk=  ;
X-YMail-OSG: vOKZOqsVM1kIVKeAN0phna0A4LYkjhHpqSfIxWEMKNcVXUvMhYFlvvtSEpAr3CRxsSNyfa5xKg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: jim@coolzero.info
Subject: Re: Oom-killer error.
Date: Wed, 7 Nov 2007 08:45:34 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <35032.212.120.65.207.1194338096.squirrel@webmail.coolzero.info>
In-Reply-To: <35032.212.120.65.207.1194338096.squirrel@webmail.coolzero.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711070845.34587.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 November 2007 19:34, Jim van Wel wrote:
> Hi there,
>
> I have a strange problem with like 10-15 servers right now.
> We have here all HP DL380-G5 servers with kernel 2.6.22.6. System all
> works normall. But after a uptime of like 15 a 25 days, we get these
> messages, and the servers is just crashed.
>

It is trying to allocate lowmem, but you have none left (and none
to speak of can be reclaimed).

I'd guess you have a kernel memory leak. Can you start by posting
the output of /proc/slabinfo and /proc/meminfo after the machine has
been up for 10-20 days (eg. close to OOM). And preferably also post
another set after just a day or so uptime.

Are you using the SLAB or SLUB allocator (check .config).

The kernel crashes (rather than recovers) because the leak has used
up all its working memory and killing processes does not release it.
(by the looks).

Thanks for the report,
Nick
