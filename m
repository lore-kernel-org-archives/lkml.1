Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYGVCCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYGVCCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGVCCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:02:35 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:28320 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753398AbYGVCCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:02:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m53ytU3lG3QrJktk8kt0JDNmiGUm9ecSg2HoqUDKHDSYAskql3znDlkCbRZhFKiOhGgBXUx0dOHMYE4qwmLvktlpfKyt8PXP3Y0htzRooGRSWNxnw13Q9k3laxU+kkziqoZaBcpGppkHT5YnZ+pB5uTzbJgR+NrIgWj2Hu9C7ck=  ;
X-YMail-OSG: IIVNYhcVM1miufO8O4b.R9vCaQQGOITacYbZaE8sxn4k9T_GGoRUJVaFYCYsf6h92YVl1LsRQDgjPbwa5sMpKyBKXKereQqXiEMHHi0YxJH7kP1EAv3VLSP8_5qj4RyhrZI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Date: Tue, 22 Jul 2008 12:02:26 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <87y73x4w6y.fsf@saeurebad.de> <200807211549.00770.nickpiggin@yahoo.com.au> <20080721111412.0bfcd09b@bree.surriel.com>
In-Reply-To: <20080721111412.0bfcd09b@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221202.27169.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 01:14, Rik van Riel wrote:
> On Mon, 21 Jul 2008 15:49:00 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > It is already bad because: if you are doing a big streaming copy
> > which you know is going to blow the cache and not be used again,
> > then you should be unmapping behind you as you go.
>
> MADV_SEQUENTIAL exists for a reason.

AFAIKS it is to open up readahead mainly. Because it is quite reasonable
to otherwise be much more conservative about readahead than with regular
reads (and of course you can't do big chunks per kernel entry)...

I don't actually care what the man page or posix says if it is obviously
silly behaviour. If you want to dispute the technical points of my post,
that would be helpful.


> If you think that doing an automatic unmap-behind will be
> a better way to go, we can certainly whip up a patch for
> that...

I don't. Don't let me stop you trying of course :)

Consider this: if the app already has dedicated knowledge and
syscalls to know about this big sequential copy, then it should
go about doing it the *right* way and really get performance
improvement. Automatic unmap-behind even if it was perfect still
needs to scan LRU lists to reclaim.
