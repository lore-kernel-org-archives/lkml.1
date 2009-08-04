Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZHDJSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZHDJSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932625AbZHDJSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:18:40 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:5693 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932584AbZHDJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:18:39 -0400
X-IronPort-AV: E=Sophos;i="4.43,320,1246831200"; 
   d="scan'208";a="30761806"
Message-ID: <4A77FCFB.9020001@inria.fr>
Date: Tue, 04 Aug 2009 11:18:51 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0
 <  get_user_pages(..., nr_pages, ...) < nr_pages?
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com> <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
>> - what should a driver do when get_user_pages() returns less pages
>> than requested?
> 
> Probably put_page the pages gotten then report the surprise;
> perhaps, before putting the pages gotten, try get_user_pages
> on the next alone, to see what error code is returned for that.

I wonder if we should change get_user_pages to store ERR_PTR(ret)
in page[i] when it fails to get page #i.

Brice
