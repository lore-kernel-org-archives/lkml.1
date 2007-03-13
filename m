Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXCMIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXCMIDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCMIDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:03:45 -0400
Received: from smtp102.plus.mail.mud.yahoo.com ([68.142.206.235]:30415 "HELO
	smtp102.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932969AbXCMIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:03:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=eVFfY3J0NO59itk63gEawfhELUvRsmr3fROSWhqfM2uxqgb8TYQhV55+s0ZnDXn3rRRyR+lfSPQhS4mvSO7QvOTW/PiXlUo4UKFpjVZuNSExgN8c6m5FCkFXoyiq6I7+0FpXqy9zlo409AhieUD5dgMMlRbSFZKn25D4/cWxuSc=  ;
X-YMail-OSG: ulgcqfsVM1k63A5cPJzVYhCUSh9mQb1Nbv2pdmDVEqNh_JsMA.FnFEJthtt54YzDR0N_RG7Q0u3tdQMMIRo9K7S6a7v5MyDwUqu1voA3uAJT_X.ONC657LvvNfPcxjDIknJnH_mMhmJUmI9hHPMHJs9loQ--
Message-ID: <45F65ADA.9010501@yahoo.com.au>
Date: Tue, 13 Mar 2007 19:03:38 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com> <20070313005334.853559ca.akpm@linux-foundation.org>
In-Reply-To: <20070313005334.853559ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 13 Mar 2007 00:13:25 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
>>Page table pages have the characteristics that they are typically zero
>>or in a known state when they are freed.
> 
> 
> Well if they're zero then perhaps they should be released to the page allocator
> to satisfy the next __GFP_ZERO request.  If that request is for a pagetable
> page, we break even (except we get to remove special-case code).  If that
> __GFP_ZERO allocation was or some application other than for a pagetable, we
> win.
> 
> iow, can we just nuke 'em?

Page allocator still requires interrupts to be disabled, which this doesn't.

Considering there isn't much else that frees known zeroed pages, I wonder if
it is worthwhile.

Last time the zeroidle discussion came up was IIRC not actually real performance
gain, just cooking the 1024 CPU threaded pagefault numbers ;)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
