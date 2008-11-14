Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYKNDRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYKNDRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYKNDRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:17:44 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:30007 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751232AbYKNDRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:17:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=EsHsHYHbyGfiRHy5377rUID5wUFcuQ+sUEl7nEXNx/ksLi8PB+T5T9C0lVKO6scdYPiT8CDS9iPe7lungYAWTFUCFr66eZn9LQXlqib7rcK2ZVscRBIcmQ050aWwXVLnx6zxthZLYW9cIXRnFJCAwFh47LVFHGVPQwTvU+cYHsw=  ;
X-YMail-OSG: u75crJ4VM1mB3RKq712BtGS4ddJgALOHR7H9go7KcSuAnZGkMsXj5CvDSW28tdYm5bybq6CEaEMZj4flM83f_F5Y3RYYJVWWgwitN04H9sICCmO6MSXOnVlyGLEL0hJROqZ6
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
Date: Fri, 14 Nov 2008 14:17:35 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <491C61B1.10005@goop.org> <200811141319.56713.nickpiggin@yahoo.com.au> <491CE8C6.4060000@goop.org>
In-Reply-To: <491CE8C6.4060000@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811141417.35724.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 13:56, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > This isn't performance critical to anyone?
>
> The only difference should be between having the specialized code and an
> indirect function call, no?

Indirect function call per pte. It's going to be slower surely.


> > I see DRM, IB, GRU, other media and video drivers use it.
> >
> > It IS exactly what apply_to_page_range does, I grant you. But so does
> > our traditional set of nested loops. So is there any particular reason
> > to change it? You're not planning to change fork/exit next, are you? :)
>
> No ;)  But I need to have a more Xen-specific version of
> remap_pfn_range, and I wanted to 1) have the two versions look as
> similar as possible, and 2) not have a pile of duplicate code.

It is accepted practice to (carefully) duplicate the page table walking
functions in memory management code. I don't think that's a problem,
there is already so many instances of them (just be sure to stick to
exactly the same form and variable names, and any update or bugfix to
any of them is trivially applicable to all).
