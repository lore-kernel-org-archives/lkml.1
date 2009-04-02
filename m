Return-Path: <linux-kernel-owner+w=401wt.eu-S1765047AbZDBQtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765047AbZDBQtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZDBQra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:47:30 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:45325 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761421AbZDBQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:47:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yJB6eCcH3u1XeL/3xHqVhdehYRmvlbzhWWT4PmpQBcyehSqpEMQuKsi/0aFaNor+fz1YFPuEbgaN2XogJwzLUtcr9xhGaE9OykcY8r9dhnuD7mA09PcSCTUyBjkjwHjnaGZOKA6+6Q7/OSWcu5OIs2cMqfvKHxxCqHhAKkD1bEA=  ;
X-YMail-OSG: xBvUmz8VM1lhlWGqGe_mr57KJmiFYaVr3xDZSkxfAa_KgOCnqmt.Gk8Q5m._EY_LrSgQQrm1lCw5KN_JkBo0Z7.IpKiy0uv73wQUEGxvy3xFJDgaFz9KMKO7MK489y5dB.C2W4rxWfQ2haTnE_y5QZoKTvSGhHeVIrr_f6PSOLvjB4KDoIBRNm9ISXt2yrDhjW6UqV1PiFlUdcduF4J5Srl5.2GzFHMoYAvcJAuT7H33vYWZKXSoERjs5nkNYS2FxQsubA7VTzyq2X0fnyrET99wGeRhoYHoaA2ns4GeohBgLSD1Xxri
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Fri, 3 Apr 2009 03:47:20 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org>
In-Reply-To: <20090402163712.GA25177@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030347.21470.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 03:37:12 Christoph Hellwig wrote:
> On Fri, Apr 03, 2009 at 02:32:58AM +1100, Nick Piggin wrote:
> > Hmm, I guess not all filesystems define write_begin/write_end. But if you
> > only need to use ones that do define them?
> 
> No.  write_begin/write_end are simply callbacks for the write helpers,
> and locking for them is entirely filesystem-defined.  E.g. xfs and the
> cluster filesystems require additional locks taken first, and some
> network filesystems require inode revalidations first.

Well they now are quite well filesystem defined. We no longer take
the page lock before calling them. Not saying it's perfect, but if
the backing fs is just using a known subset of ones that work
(like loop does).


> They really should be taken out of the address_space_operations and
> passed as callbacks to generic_file_aio_write & co.

Probably yes. But it seems like it should have more discussion IMO
(unless it has already been had and I missed it).

I don't think "write_one_page" sounds like a particularly good new
API addition.

In the meantime, I would prefer cachefs use writebegin/end and it can
be converted to a new API with everyone else rather than having to
rush a new API in with it.
