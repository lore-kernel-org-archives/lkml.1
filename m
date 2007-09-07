Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIHIPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIHIPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXIHIPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:15:43 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:24085 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751370AbXIHIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:15:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VQjhI9O/hhH5wSDTaicivYHVsXXfoZD1O5MxGobCdEutUtm2ATH3WE6ZZrr5jb5ydzsZZr57xecU3xSJotOBIQG2naQuFR/laPSyJkkUKRoFhA8HhaH/+NOgCRvI7txvZNRJcObExj95K0N46+e/znxvpV+oi1xLgL2CSmTFHnA=  ;
X-YMail-OSG: ckER2D0VM1lGfnyKWhapaJDRw1WBVHbpkaaIyTx1LUDSaqWdLGTjOrcK1dwVErKMaqa6wSbPVA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 04:13:12 +1000
User-Agent: KMail/1.9.5
Cc: ak@suse.de, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709090334.27677.nickpiggin@yahoo.com.au> <200709090348.28076.nickpiggin@yahoo.com.au>
In-Reply-To: <200709090348.28076.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080413.12282.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007 03:48, Nick Piggin wrote:

> There is some suggestion in the source code that non-temporal stores
> (movntq) are weakly ordered. But AFAIKS from the documents, it is ordered
> when operating on wb memory. What's the situation there?

Sorry, it looks from the AMD document like nontemporal stores to wb
memory can go out of order. It is a bit hard to decipher what the types
mean.

If this is the case, we can either retain the sfence in smp_wmb(), or noop
it, and put explicit sfences around any place that performs nontemporal
stores...

Anyway, the lfence should be able to go away without so much trouble.
