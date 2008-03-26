Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbYCZAei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbYCZAei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbYCZAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:34:19 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:2175 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbYCZAeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tv52kkOPuMwFLsaWqGK0BhtfV9FrBsHgMz3ZEFJaMih3MpANWc+I/Hd8JgbgDLNMSnOctgEPz4CAb6AQvZz58Qh0bhcJwhbhXOcDpKrwkTicp6KfYtrpEO6Ah21Ed+Zi9ZXUIUq/VMmU2KvAPQ+kAajLuH8IPa5ZRtB7bP6Tz9U=
Message-ID: <ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
Date: Tue, 25 Mar 2008 18:34:13 -0600
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Peter Chubb" <peterc@gelato.unsw.edu.au>
Subject: Re: larger default page sizes...
Cc: "David Miller" <davem@davemloft.net>, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org, ianw@gelato.unsw.edu.au
In-Reply-To: <87tziu5q37.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0803241402060.7762@schroedinger.engr.sgi.com>
	 <20080324.144356.104645106.davem@davemloft.net>
	 <Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
	 <20080325.162244.61337214.davem@davemloft.net>
	 <87tziu5q37.wl%peter@chubb.wattle.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 5:41 PM, Peter Chubb <peterc@gelato.unsw.edu.au> wrote:
>  The main issue is that, at least on Itanium, you have to turn off the hardware
>  page table walker for hugepages if you want to mix superpages and
>  standard pages in the same region. (The long format VHPT isn't the
>  panacea we'd like it to be because the hash function it uses depends
>  on the page size).

Why not just repeat the PTEs for super-pages?  That won't work for
huge pages, but for superpages that are a reasonable multiple (e.g.,
16-times) the base-page size, it should work nicely.

  --david
-- 
Mosberger Consulting LLC, http://www.mosberger-consulting.com/
