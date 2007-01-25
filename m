Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXAYIHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXAYIHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXAYIHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:07:22 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:49621 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965696AbXAYIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:07:21 -0500
Message-ID: <45B8652B.5040200@linux.vnet.ibm.com>
Date: Thu, 25 Jan 2007 13:37:07 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Erik Andersen <andersen@codepoet.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Aubrey Li <aubreylee@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <1169625333.4493.16.camel@taijtu> <45B7561C.9000102@yahoo.com.au> <Pine.LNX.4.64.0701240657130.9696@schroedinger.engr.sgi.com> <20070124200614.GA25690@codepoet.org> <Pine.LNX.4.64.0701241840090.12325@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701241840090.12325@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> On Wed, 24 Jan 2007, Erik Andersen wrote:
> 
>> It would be far more useful if an application could hint to the
>> pagecache as to which files are and which files as not worth
>> caching, especially when the application knows a priori that data
>> from a particular file will or will not ever be reused.
> 
> It can give such hints via madvise(2).

I think you meant fadvise.  That is certainly a possibility which we
need to work on.  Current implementation of fadvise only throttles
read ahead in case of sequential access and flushes the file in case
of DONTNEED.  We leave it at default for NOREUSE.

In case of DONTNEED and NOREUSE, we need to limit the pages used for
page cache and also reclaim them as soon as possible.  Interaction of
 mmap() and fadvise is little more dfficult to handle.

--Vaidy

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
