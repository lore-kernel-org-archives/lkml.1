Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXLBNZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXLBNZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXLBNY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:24:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXLBNY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:24:56 -0500
Date: Sun, 2 Dec 2007 11:24:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: Andy Whitcroft <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20071202132440.GM30008@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Christer Weinigel <christer@weinigel.se>,
	Andy Whitcroft <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
References: <20071202130335.690a8daf@cw05lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202130335.690a8daf@cw05lap>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 02, 2007 at 01:03:35PM +0100, Christer Weinigel escreveu:
> Hi Andy,
> 
> you seem to be the last person messing around with checkpatch.pl so I'm
> addressing this to you. :-)
> 
> checkpatch complains about the following:
> 
> WARNING: no space between function name and open parenthesis '('
> #520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
> +       list_for_each_entry (transfer, &message->transfers, transfer_list) {
> 
> which I think is a bit bogus since it actually is a for statement in
> disguise.  The following patch adds list_for_each to the list of things
> that look like functions that it shouldn't complain about.

Then you would have to do this for tons other *_for_each*, such as
hlist_for_each, etc, but:

[acme@doppio net-2.6.25]$ find . -name "*.[ch]" | xargs grep
'_for_each[a-z_]*(' | wc -l
4370
[acme@doppio net-2.6.25]$ find . -name "*.[ch]" | xargs grep
'_for_each[a-z_]* (' | wc -l
160
[acme@doppio net-2.6.25]$

I'd say that the common practice in the * _for_each_* use is to do just
what checkpatch does right now, complain if the is a space. Ah, and that
is also my personal preference 8-)

- Arnaldo
