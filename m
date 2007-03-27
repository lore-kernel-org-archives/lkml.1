Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXC0SGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXC0SGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934124AbXC0SGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:06:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934088AbXC0SGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:06:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ihee5A31dQiLe2SOS7OqljNlwj7eI8rhRSAl5fEuxjz77FUQpBKW1oWkX4SA71j22
	5IHTtBl8nctTRTmEQnNgw==
Message-ID: <b040c32a0703271106y427d3850y4836ec61ab49942c@mail.gmail.com>
Date: Tue, 27 Mar 2007 11:06:24 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <p737it2689e.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	 <p737it2689e.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Mar 2007 17:01:01 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> What is the problem? You have cache misses on the the hash table
> or are the instructions really an issue on a modern CPU?

It was page_to_pfn() on numa system.  I think it's cache misses on per
node pgdat lookup with node index calculation on each pipe buffer
page.


> e.g. i out of lined virt_to_page to save space, but it could be probably
> inlined again if it was severly time critical.

That would be a problem too, though not showing up in the pipe code path.
