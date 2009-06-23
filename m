Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZFWLOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZFWLOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZFWLNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:13:54 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:60646 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbZFWLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:13:53 -0400
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
Date: Tue, 23 Jun 2009 13:13:53 +0200
User-Agent: KMail/1.9.9
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906222101.38586.elendil@planet.nl> <200906230951.24615.elendil@planet.nl> <20090623.035926.155211513.davem@davemloft.net>
In-Reply-To: <20090623.035926.155211513.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231313.55057.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2009 11:13:55.0494 (UTC) FILETIME=[B28CBC60:01C9F3F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, David Miller wrote:
> Therefore, any objections to something like this?
>
> ide-cd: Don't warn on bogus block size unless it actually matters.
>
> Frans Pop reported that his CDROM drive reports a blocksize of 2352,
> and this causes new warnings due to commit
> e8e7b9eb11c34ee18bde8b7011af41938d1ad667 ("ide-cd: fix oops when using
> growisofs").
>
> What we're trying to do is make sure that "blocklen >> SECTOR_BITS"
> is something the block layer won't choke on.
>
> And for Frans case "2352 >> SECTOR_BITS" is equal to
> "2048 >> SECTOR_BITS", and thats "4".

So basically there's garbage in unused bits?

> So warning in this case gives no real benefit.

Fine by me. I'll be glad to be rid of that error :-)
I'll give your patch a try with my next build.

But I think my patch still makes sense for those cases where the original 
error _does_ exist. Unless your patch fixes those as well, but we can't 
know that for sure, can we?
