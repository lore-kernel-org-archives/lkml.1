Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbXBNUsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbXBNUsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXBNUrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:47:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXBNUrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:47:43 -0500
Date: Wed, 14 Feb 2007 15:47:31 -0500
From: Dave Jones <davej@redhat.com>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page on Geode
Message-ID: <20070214204731.GA4551@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Jordan Crouse <jordan.crouse@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070214190839.GA4864@dmt.lan> <20070214195546.GA2005@redhat.com> <20070214201736.GA5794@dmt.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214201736.GA5794@dmt.lan>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 06:17:36PM -0200, Marcelo Tosatti wrote:
 > On Wed, Feb 14, 2007 at 02:55:46PM -0500, Dave Jones wrote:
 > > On Wed, Feb 14, 2007 at 05:08:39PM -0200, Marcelo Tosatti wrote:
 > >  > 
 > >  > movntq instruction is supported by Geode CPU's, so use
 > >  > fast_clear_page/fast_copy_page versions that have it.
 > > 
 > > it's supported, but is it a win ?
 > > The same was also true of the VIA C3/C7's, but due to
 > > poor memory bandwidth, it turned out to be slower in most cases.
 > 
 > Do you have the numbers for VIA C3/C7 around?

I don't, and my 3dnow capable C3s are unplugged right now.
The newer generation (including the C7) have SSE/SSE2 instead,
which seems to be faster.  (Using a different benchmark app that uses SSE)

clear_page function 'normal clear_page()'        took 9425 cycles per page (620.3 MB/s)
clear_page function 'new clear_page()   '        took 3840 cycles per page (1522.7 MB/s)

copy_page function 'normal copy_page()'  took 11453 cycles per page (510.5 MB/s)
copy_page function 'new copy_page()   '  took 5024 cycles per page (1163.7 MB/s)


		Dave

-- 
http://www.codemonkey.org.uk
