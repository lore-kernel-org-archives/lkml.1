Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZDDF4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZDDF4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 01:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDDFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 01:55:58 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:46836 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753516AbZDDFz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 01:55:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4y3QpGrgO0tAHR8Dxp7jhWy2SzvXLZyUt9IdwbC4Jbt09tLAAtTQ11qy3t/+uceJlbmNccfhQrMJJOjw7UWaiNBiy1ocX+LFoqgPQbJ0Ywdr3si6G5euexngRJnESuTaVtPMARoMusBwm94+Wwt6ywNbWg+3NhoZf8eh1GmtgX8=  ;
X-YMail-OSG: QaxW9L4VM1kfWuMlg21UFIJvgmgavJq0E2WBLtuYqQLSnItvL9HbCeR_4Glvi24v3JxvwEe1ZPdw3hj5Db4Wky5DK1GK6vYVOKPpVUDuq3K0Ft_NMHDezNn5fNYq1iHHIyncWhGExX2.HczdWRRzCdAReCKG4NxjKq_9fs0jmXSPfaeJHW5JqxaMo23MeYtimiOSkVFRN4Ufv9LIwddXZ8MbUyfn95AEHp1ZSTd_Q0ziQUh_BaJtpAWlgkIlQKqqhmd5G4P3jrLKfAAY5XNpN12B5xoKjfFSvOGZh69EAJpFAm9WjYA.k.Zrwr9lhfFgxzsrsc6EbwM_gYEJSfV.E4R1Mg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/4] CacheFiles: Revert the addition of write_one_page()
Date: Sat, 4 Apr 2009 16:55:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Hellwig <hch@infradead.org>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20090403135007.GB31907@infradead.org> <20090403094143.9510.80474.stgit@warthog.procyon.org.uk> <10983.1238766809@redhat.com>
In-Reply-To: <10983.1238766809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904041655.43360.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009 00:53:29 David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Note that in the patch series going into mainline eventually this should
> > not be a separate patch but the new ops should never be introduced.
> 
> Yes, probably, but this makes it easier for people to see what I'm proposing
> to change.

Definitely yes please. kmap resources are not infinite but there is obviously
a proper kmap allocator so long as you only kmap one page at a time, then
others will just block waiting for more. On sane platforms of course there
is no penalty at all.

So this change is definitely required if you want to get this patchset in.
The alternative is to come up with a new API and get that merged first, but
I figure you don't want that kind of dependency.
