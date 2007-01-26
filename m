Return-Path: <linux-kernel-owner+w=401wt.eu-S1030790AbXAZGaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbXAZGaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030796AbXAZGaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:30:55 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:33125 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030790AbXAZGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:30:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=p4gEyZxqBs8+i+rHDwCnGuHXkA7dwdmmsUAiPdy525E2n0/+uTOeA3bDZjPz6uZbfS05Ua0NTRX3pd2XIqK6CLMDFRHvTj3Ms7dOkiRvpjowDkLkCrm7DEpiJeVJhfij2ApQVkS1yHDzsoY8R6gxAji8DdAsfvx+0cDCZlqBRJo=  ;
X-YMail-OSG: ozvk53wVM1m7.xSnETD_n8BCKZDpQndEHq27532GYG5rg8EwGFzwAOm6rAR16DUjgkJd6eUhYok4rWMMUXqBgys8GfpJ.dt10tf.AvuE4A7og4r4W7w-
Message-ID: <45B9A00C.4040701@yahoo.com.au>
Date: Fri, 26 Jan 2007 17:30:36 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Add NR_MLOCK
> 
> Track mlocked pages via a ZVC

I think it is not quite right. You are tracking the number of ptes
that point to mlocked pages, which can be >= the actual number of pages.

Also, page_add_anon_rmap still needs to be balanced with page_remove_rmap.

I can't think of an easy way to do this without per-page state. ie.
another page flag.

> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
