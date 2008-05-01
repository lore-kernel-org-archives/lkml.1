Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbYEAV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbYEAV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761919AbYEAV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:27:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45287
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756835AbYEAV1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:27:32 -0400
Date: Thu, 01 May 2008 14:27:31 -0700 (PDT)
Message-Id: <20080501.142731.262496403.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: viro@ZenIV.linux.org.uk, bharrosh@panasas.com, harvey.harrison@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression
 warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209644226.16449.11.camel@lappy>
References: <4819ACF6.9000403@panasas.com>
	<20080501120016.GV5882@ZenIV.linux.org.uk>
	<1209644226.16449.11.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 01 May 2008 14:17:06 +0200

> On Thu, 2008-05-01 at 13:00 +0100, Al Viro wrote:
> > On Thu, May 01, 2008 at 02:43:50PM +0300, Boaz Harrosh wrote:
> > 
> > > I don't know who invented sparse, but I like this form of return.
> > > 1 - It saves me the curly brackets and extra return line. But mainly
> > > 2 - It is a programing statement that says: "Me here I'm an equivalent 
> > >   to that other call". So if in the future that inner function starts
> > >   to return, say, an error value, with the first style the compiler will
> > >   error. But with the second style the new error return will be silently
> > >   ignored. So these are not equivalent replacements. The former is a much
> > >   stronger bond between the caller and the callie.
> > 
> > 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> > a function whose return type is void.
> > 
> > Write in C, please.
> 
> We use GNU99 all over the place, or are you going to clear up all the
> statement expressions and such other fancy gnu extensions to the
> language as well?
> 
> I'm really not seeing why this would be wrong, other than the standard
> saying it is, ie. I think the standard got it wrong here.
> 
> Harvey can just use -Wno-return-void, or someone can modify sparse to
> have that default disabled for STANDARD_GNU[89]9.

Even Linus thinks this construct is fine and said he had a patch to
make sparse allow it.  This discussion is pointless especially since
GCC has allowed this since basically day one, and it's even self
consistent.
