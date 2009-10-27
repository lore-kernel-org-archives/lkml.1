Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZJ0Rfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZJ0Rfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZJ0Rfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:35:38 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54997 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZJ0Rfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:35:37 -0400
Date: Tue, 27 Oct 2009 10:35:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: better name hash function
Message-ID: <20091027103536.28cf0a0f@nehalam>
In-Reply-To: <4AE72B91.7040700@gmail.com>
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
	<4AE68E23.20205@gmail.com>
	<4AE69829.9070207@gmail.com>
	<4AE6A16F.4020002@gmail.com>
	<20091027100736.5303f1ab@nehalam>
	<4AE72B91.7040700@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 18:19:13 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Stephen Hemminger a écrit :
> 
> > So Eric's string10 is fastest for special case of fooNNN style names.
> > But probably isn't best for general strings. Orignal function
> > is >20% slower, which is surprising probably because of overhead
> > of 2 shifts and multipy. jenkins and fnv are both 10% slower.
> > 
> 
> 
> jhash() is faster when strings are longer, being able to process 12 bytes per loop.
> 

But jhash is not amenable to usage in namei (with partial_name_hash).

name_hash is rarely done on long strings, the average length of a filename
is fairly short (probably leftover Unix legacy). On my system, average
path component length in /usr is 13 characters; therefore jhash has
no big benefit here.
