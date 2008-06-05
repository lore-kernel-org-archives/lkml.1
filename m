Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYFEQBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYFEQBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYFEQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:01:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYFEQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:01:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s+oKUxJCXLNAq0tAzZ/wX5Q/Vr/hMxVHP4z3EbG1ThoxBGQ/49WrHMDgZ5fK7AbWl
	OHzl00RwxegRNDc30hihg==
Message-ID: <4ca0a85e0806050901q52deba94r3056fdb0e7d46c8c@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:01:06 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user instead of put_user.
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1212681477.3953.154.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
	 <1212681477.3953.154.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 11:57 AM, Matt Mackall <mpm@selenic.com> wrote:
>
> On Thu, 2008-06-05 at 11:04 -0400, Thomas Tuttle wrote:
>> While fiddling with pagemap, I discovered a bug in add_to_pagemap.
>> When it is copying an entry that is not at the end of the buffer, it
>> uses put_user to copy a u64 into a char* buffer.  The problem is that
>> put_user determines how much to copy based on the size of the
>> *destination*, not the source, so it only copied one byte.  To fix
>> this, I replaced the call to put_user with a call to copy_to_user, as
>> is used when copying the last (possibly partial) PFN into the buffer.0
>
> This looks fine to me, so:
>
> Acked-by: Matt Mackall <mpm@selenic.com>
>
> But your 3/5 undoes this, right? So we should just take one or the other
> route. While I like going the simplifying route, it's not very pretty
> from the user interface point of view. But it does have plenty of
> precedent in direct-I/O-like things.

No, my 3/5 further keeps the use of copy_to_user instead of put_user,
but eliminates entirely the code for partial reads.  3/5 depends on
1/5.

--ttuttle
