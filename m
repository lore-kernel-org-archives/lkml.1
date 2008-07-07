Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYGGKnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYGGKnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYGGKnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:43:42 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:22805 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752353AbYGGKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:43:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WiNJaL3oG844GqohE756id0RybWhmySHRhqsB8ckO+f7atqWdcDEv3ZxBlDo43HLAa0ou+rNn9PSUtx2FQKn79mvc84L6nVtGQeioTcKsPdpWEvMbmhDZ856IawHt6DZen5Ufc+GNaYOVwFfa8bDcbkd2FRa6+RY0ndevqWJKas=  ;
X-YMail-OSG: o0c3WxoVM1lfexcQfYN945mv8fKznHXSnhCv_BGNQjQjn8kEBUMYqeACdcDPqnvr1_f0dhliDrLfEhOv7jaAL_8CyFNbVGgQvZkn_T_g.G7YBjI7Knf0CNs0WXOgw7SN430-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Date: Mon, 7 Jul 2008 20:43:16 +1000
User-Agent: KMail/1.9.5
Cc: jamie@shareable.org, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com
References: <20080625124038.103406301@szeredi.hu> <200807071638.32955.nickpiggin@yahoo.com.au> <E1KFmuc-0001VS-RS@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KFmuc-0001VS-RS@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072043.16522.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 19:21, Miklos Szeredi wrote:
> On Mon, 7 Jul 2008, Nick Piggin wrote:
> > I don't know what became of this thread, but I agree with everyone else
> > you should not skip clearing PG_uptodate here. If nothing else, it
> > weakens some important assertions in the VM. But I agree that splice
> > should really try harder to work with it and we should be a little
> > careful about just changing things like this.
>
> Sure, that's why I rfc'ed.
>
> But I'd still like to know, what *are* those assumptions in the VM
> that would be weakened by this?

Not assumptions (that I know of, but there could be some) but
assertions. For example we assert that pages in page tables are
always uptodate. We'd miss warning if we had an invalidated page
in the pagetables after this change.
