Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYCKTLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYCKTLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYCKTLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:11:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbYCKTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:11:41 -0400
Date: Tue, 11 Mar 2008 12:11:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: akinobu.mita@gmail.com, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Message-Id: <20080311121107.4774ff5e.akpm@linux-foundation.org>
In-Reply-To: <1205261815.3165.21.camel@localhost>
References: <20080310145704.GA6396@APFDCB5C>
	<20080310204853.3108d21c.akpm@linux-foundation.org>
	<200803111510.52761.nickpiggin@yahoo.com.au>
	<20080310212108.5882011e.akpm@linux-foundation.org>
	<961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com>
	<20080311103517.5b6dc23f.akpm@linux-foundation.org>
	<1205261815.3165.21.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 11:56:55 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2008-03-11 at 10:35 -0700, Andrew Morton wrote:
> > #define ONCE()                                              \
> >     ({                                              \
> >             static long flag;                       \
> >                                                     \
> >             return !test_and_set_bit(0, flag);      \
> >     })
> 
> test_and_set_bit takes an address

duh.

> Perhaps:
> 
> #define DO_ONCE(x) \
> 	({ static long flag; if (test_and_set_bit(0, &flag)) x; 1; })
> 
> DO_ONCE(foo);

No, that's completely unnecessary and would produce nasty-looking code. 
Take a look at some of the wait_event monstrosities we have.


I'm not sure that we need any of this once() stuff really.
