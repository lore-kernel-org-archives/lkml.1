Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYFWHQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYFWHQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYFWHPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:15:52 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40999 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752258AbYFWHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:15:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=csfIKHXioAXbzNs5RaPk/zyJYQTy7e18ibyKr3QGSmZEnn/hQGk4kL5oYnSmB3LdQQh6w78/gs/v5QYTcq2uf168fMbqd02pUjGDeNcjtOgnjDt2Zn/p55g0T9m+DzMZZj6hLhyhfIUyDhvCQ6HIK1/UJ11h5Lo27t54+tOZcEU=  ;
X-YMail-OSG: j1FAYQQVM1luolqsWmoCbrCNcjEwD4bDg5v0fP7djIzLhAIpARb7j9EPCcqoACjrdIdBif_7gRtkM_q16H9Af7kRQimK7VifIj6ch7ptEThpFZQ_VrCLvpf8LoCIVw8X5Sg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Date: Mon, 23 Jun 2008 00:15:49 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
References: <200806221954.37088.david-b@pacbell.net> <20080623065034.GG20122@cs181140183.pp.htv.fi>
In-Reply-To: <20080623065034.GG20122@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230015.49973.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008, Adrian Bunk wrote:
> On Sun, Jun 22, 2008 at 07:54:36PM -0700, David Brownell wrote:
> > This updates <linux/bcd.h> to define the key routines as static
> > constant functions, which the macros will then call.
> > 
> > 	... Typical per-driver savings top 200 bytes. ...
> 
> The patch breaks the compilation:

Needs to #include <linux/types.h> then; "u8" isn't always known.
Or maybe just spell it out "unsigned char".


>	...
> 
> Additionally, I'd suggest to make them out-of-line functions 
> instead of shipping multiple copies in different object files.

That was one of the options.  I thought I'd start with something
simpler, and see what folk thought.

Where would that be ... lib/bcd.c, always linked?  And if it goes
that way I'd prefer bcd2bin() and bin2bcd(), not these names.  A
small impetus to have LESS SOURCE CODE SHOUTING AT ME.

- Dave
