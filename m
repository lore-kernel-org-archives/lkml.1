Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbYEAMRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbYEAMRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYEAMRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:17:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39209 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYEAMRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:17:37 -0400
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression
	warnings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080501120016.GV5882@ZenIV.linux.org.uk>
References: <1209593024.24729.119.camel@brick>
	 <4819ACF6.9000403@panasas.com>  <20080501120016.GV5882@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:17:06 +0200
Message-Id: <1209644226.16449.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 13:00 +0100, Al Viro wrote:
> On Thu, May 01, 2008 at 02:43:50PM +0300, Boaz Harrosh wrote:
> 
> > I don't know who invented sparse, but I like this form of return.
> > 1 - It saves me the curly brackets and extra return line. But mainly
> > 2 - It is a programing statement that says: "Me here I'm an equivalent 
> >   to that other call". So if in the future that inner function starts
> >   to return, say, an error value, with the first style the compiler will
> >   error. But with the second style the new error return will be silently
> >   ignored. So these are not equivalent replacements. The former is a much
> >   stronger bond between the caller and the callie.
> 
> 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> a function whose return type is void.
> 
> Write in C, please.

We use GNU99 all over the place, or are you going to clear up all the
statement expressions and such other fancy gnu extensions to the
language as well?

I'm really not seeing why this would be wrong, other than the standard
saying it is, ie. I think the standard got it wrong here.

Harvey can just use -Wno-return-void, or someone can modify sparse to
have that default disabled for STANDARD_GNU[89]9.

