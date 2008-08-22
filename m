Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYHVBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYHVBiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYHVBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:37:59 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:22751 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751638AbYHVBh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:37:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dkH75wlXw2clZ4zCuI7Re5iZDEEDUvHYWjOgJdI/+yxlN6VF3/qPEASkX43PrTw7LwN50j45b3RpktD6mg3CEck4SdB+bPyM1QJy2wf3A+Oyz0WcSW+8d1nMbOeMHkl7prNs1jh1xuY1Lhwa+5BXySs/8JnfH69pnd2D5kD3u9g=  ;
X-YMail-OSG: k31MPxQVM1niW.FlSt12tUWEOrLlJSEtdgVUN19Zwx1gcekJkAXCq0JFGY7rVRpVOSrHFZkEUR77o8.RlAA89NjI9VgNsZzQJSPJQLBhwR4aASYt6lRhIa3_Ah6rUJZ5y1E01ugFiKwW8K0igyl5n3c7
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 released
Date: Fri, 22 Aug 2008 11:37:50 +1000
User-Agent: KMail/1.9.5
Cc: jmerkey@wolfmountaingroup.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au> <48ADD8DE.3010209@goop.org>
In-Reply-To: <48ADD8DE.3010209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221137.50509.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 07:06, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
> >> I used the smp_wmb() functions.  I noted a couple of things.  a) some of
> >> these macros just emit __asm__ __volatile__ into the code so why not
> >> just say "volatile" to begin with
> >
> > It is not the same as volatile type. What it does is tell the compiler
> > to clobber all registers or temporaries. This something pretty well
> > defined and hard to get wrong compared to volatile type.
>
> No, that's not what "asm volatile" means.  Its *only* meaning is "emit
> this, even if it doesn't look like it has side-effects and its results
> are not used".  An asm() with no outputs is "volatile" by default, which
> makes most of the uses of "asm volatile" in the kernel redundant.  "asm
> volatile" also has no effect on the ordering of the asm with respect to
> other code; you must use constraints to do that.
>
> An asm with a "memory" clobber is sufficient to make sure that gcc
> doesn't cache memory values in registers; perhaps that's what you mean.

That is what I meant, yes.
