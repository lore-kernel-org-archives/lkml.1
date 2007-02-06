Return-Path: <linux-kernel-owner+w=401wt.eu-S965467AbXBFVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467AbXBFVBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965471AbXBFVBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:01:46 -0500
Received: from web25003.mail.ukl.yahoo.com ([217.12.10.39]:22893 "HELO
	web25003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965467AbXBFVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:01:45 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 16:01:45 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=QtUCFC1JMggLxXLV8McEom1PkKLVG9O+dmZm9UGS8+G//WL4bxK98pW4IHn92zhvt777af9xTHStcZVX0FrGb2f/M0Rh/308L+Vnt03zXfkBdpNJK9F1J1kMU04M5WJzBPyJ7Wrydw2V+Z5otEQsjujlR+svIeIrMuFUGSd0TDA=;
X-YMail-OSG: QqRJvl8VM1md9W2WeFaumPa0JDjW1MvouhuJHWWCszYLZG7DNyXi7hiusoCGRfiPOl7txqOA6PxzVlUUglAfAlj31TvXW.M_P51.4QZnppE.OdVKV3HgQ6WxivZfXvB1OhmX04Bp7BPN3Fr4El4mkULCcT6Ev9k9r_tbGDvM9Ex9P5fPQEGlO4D8hA--
Date: Tue, 6 Feb 2007 20:55:03 +0000 (GMT)
From: Steven Newbury <s_j_newbury@yahoo.co.uk>
Subject: Re: cache coherecy when working with cpu dcache write allocate
To: saeed bishara <saeed.bishara@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <c70ff3ad0702061031i6face64ai946d6893b960645b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <598785.29036.qm@web25003.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- saeed bishara <saeed.bishara@gmail.com> wrote:

> Hi,
>     I came across data corruption problem when using xfs, my system is
> arm 926, the data cache is virtually tagged and virtually indexed and
> with no hw cache coherency. my CPU features the data cache write
> allocate-> when doing store, the cache line of the destination address
> is loaded to data cache.
>   when enabling the write allocate, I got data corruption with the
> xfs. the scenario is that the xfs allocates large buffer (for reading
> the log records) using vmalloc, and the low level driver (raid) copies
> the data to the bio vectors using the linear address, since the write
> allocate is enabled,  the correct data remains on the data cache with
> the linear address tag, when the IO completes, the xfs access the data
> with using the vmalloc virtual address, which is different than the
> kernel linear address, thus it will get a stale data!.
> 
> how should I fix this problem? I thought that only the
> copy/clean_user_pages() functions should be aware to the write
> allocate.
I wonder if I'm seeing this with reiser4 on pxa27x as well???

Steve


		
___________________________________________________________ 
Now you can have your favourite RSS headlines come to you with the all new Yahoo! Mail. http://uk.docs.yahoo.com/nowyoucan.html
