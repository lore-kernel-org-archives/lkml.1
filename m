Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZAVIUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZAVIUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZAVIUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:20:31 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47237 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZAVIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:20:30 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Thu, 22 Jan 2009 13:50:21 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901191700.03580.chandru@in.ibm.com> <1232584180.27278.86.camel@nimitz>
In-Reply-To: <1232584180.27278.86.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221350.21601.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 05:59:39 Dave Hansen wrote:
> Let's take, for instance, a 1-byte reservation.  With this code, you've
> suddenly turned that into a 0-byte reservation, and that *can't* be
> right.  The same thing happens if you have a reservation that spans two
> pages.  If you unconditionally round it down, then you might miss the
> part that spans a portion of the second page.
> 
> It needs to be rounded down like you are suggesting here, but only in
> the case where we've gone over the *CURRENT* node's boundary.  This is
> kinda what that "if (end_pfn > node_ar.end_pfn)" check is doing.  But,
> it evidently screws it up if the overlap isn't by an entire page or
> something.

I assumed the condition 'while (start_pfn < end_pfn  && .. )' asks for atleast
a PAGE_SIZE difference between them and hence went ahead with that patch.
My guess was a 1-byte , 2-byte or a (PAGE_SIZE -1)-byte reservations may not even
go into that loop.  However we just need a fix for this problem. So if there is a 
better fix that you have please post it to lkml. 

Thanks,
Chandru
