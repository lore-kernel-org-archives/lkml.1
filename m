Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYJADNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYJADNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYJADNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:13:46 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62013 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYJADNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VFh2i5imTgV53ZCM+1W/7dPi2j1Lfy1Deyihe3kKsD8Ww2tl8DP6ehF1NF95DIA/1O
         l49psuvhTGO/enKPPKL3IAJxME2BfoPgWgYOBn3iiwfg1OfSDrNlcj9TcKsZrlgshCNk
         gU9CLp1OFp7HcnqWqb904sT9y6GPY1P166YTY=
Message-ID: <a36005b50809302013w54db0985o635bcbef05a9e8f3@mail.gmail.com>
Date: Tue, 30 Sep 2008 20:13:44 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <48E205BE.8030908@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080926173219.885155151@twins.programming.kicks-ass.net>
	 <20080927161712.GA1525@elte.hu>
	 <200809301721.52148.nickpiggin@yahoo.com.au>
	 <1222764669.12646.26.camel@twins.programming.kicks-ass.net>
	 <48E205BE.8030908@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 3:55 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> I am not sure how it could be converted to private futexes, since
> old binaries (static glibc) will use FUTEX_WAKE like calls.

We considered this back when but any effort seems too much.  We'd
either need a clone flag (a scarce resource) or replace the set_tid
_address syscall.  Given that the futex is woken once per thread
lifetime it shouldn't be an issue.  If the semaphore shows up even
after this patch feel free to introduce a new set_tid_address syscall.
