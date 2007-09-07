Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbXIHKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbXIHKwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbXIHKw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:52:26 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:42031 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156AbXIHKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:52:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xiITumfA8Y+jmVx49oMu0hoJ4vvRqSkHcSPKh8kgqzIXrwgC9mbM2AZSAr/13s3v3zThBpG+piCFuC8N5fJVgfpH1Au0cX2LhqrNpFXHBDN4a5Kxx7tBvwSLRxqNfzYUuQBPpkg4IqCMxhLzokemyOB/Ha9aO0K/eG5DxVEiBc4=  ;
X-YMail-OSG: T72W.w4VM1mTaRpPeLtu.oj69BfUIu3NAnkJ7jIfcnoKz74WZAswndSIey4PiyZA4W61dL_ogbPlKEHUmydn3Q2gO_9pyY2KHKkB
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 06:49:53 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <20070908112922.3fd41adc@the-village.bc.nu>
In-Reply-To: <20070908112922.3fd41adc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080649.53876.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 20:29, Alan Cox wrote:
> On Fri, 7 Sep 2007 15:26:50 -0700
>
> Jesse Barnes <jesse.barnes@intel.com> wrote:
> > FYI, we just released a new white paper describing memory ordering for
> > Intel processors:
> > http://developer.intel.com/products/processor/manuals/index.htm
> >
> > Should help answer some questions about some of the ordering primitives
> > we use on i386 and x86_64.
>
> Nice - but it appears to be 64bit only - and indeed it appears to be
> untrue for real 32bit because of the Pentium Pro fencing errata.

As I said, we're not doing anything special in barriers for the ppro errata
today anyway.


> The kernel also runs on IDT Winchip, Cyrix and AMD processors not all of
> which have exactly the same behaviour (the IDT Winchip as we run it
> profoundly differs)

AMD processors guarantee loads are ordered and stores are ordered
(with exceptions of non-temporal, and non-wb policy).

As for the others that do out of order stores, are any of them SMP?
