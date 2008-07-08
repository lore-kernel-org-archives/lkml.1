Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYGHCWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYGHCWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 22:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYGHCWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 22:22:31 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:27821 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754873AbYGHCWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:22:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Fik4DitUsNgUNL4zxmKQQul70SXZVxo65k9vYucsl93nofbbfyqqGOzCqtl3Y30vTGYizYvhM4oC0JUBc9ZmJfBEsTaFW7gPRLi/S3qLFACm9grb8NQEjYiPikSMj3xGfIiB82YmHGe1hZMVbKEg4VEhFdHC1LEGSdYAjpaOlqE=  ;
X-YMail-OSG: 3n8HFNwVM1mMAYJJUxCITbv_yUCFxbePguRlX3sjSMnle3w2o6nvNK155ddPUxNXp3dk61k6VQmLDJvG2chXo7EqBwQWfgvZ0.hXFlt8smeFOy7rQPgsn8FAwIzFFXkAQtY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Date: Tue, 8 Jul 2008 12:22:07 +1000
User-Agent: KMail/1.9.5
Cc: jamie@shareable.org, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com
References: <20080625124038.103406301@szeredi.hu> <200807080028.00642.nickpiggin@yahoo.com.au> <E1KFsKI-0002IN-ES@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KFsKI-0002IN-ES@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081222.07633.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 01:08, Miklos Szeredi wrote:
> On Tue, 8 Jul 2008, Nick Piggin wrote:

> > > Well, other than my original proposal, which would just have reused
> > > the do_generic_file_read() infrastructure for splice.  I still don't
> > > see why we shouldn't use that, until the whole async splice-in thing
> > > is properly figured out.
> >
> > Given the alternatives, perhaps this is for the best, at least for
> > now.
>
> Yeah.  I'm not at all opposed to improving splice to be able to do all
> sorts of fancy things like async splice-in, and stealing of pages.
> But it's unlikely that I will have the motivation to implement any of
> them just to fix this bug.

Yeah. Well then, would you mind having another cut at the patch to
do that? I guess it might help if you don't remove the ->confirm
code -- after fixing the bug then we could discuss what to do with
that code and how we could implement async.

I guess it would be nice to find something that gets a lot of
benefit with the async splicing. Luckily the existing scheme is
workable enough that it would be easy to test a hunch just by
patching it back in...
