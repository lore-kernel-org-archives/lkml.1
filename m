Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXGQRoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXGQRoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXGQRoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:44:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbXGQRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:44:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UNniSyWOUQ262f6T40InGf1fstvd2cxfC5gEJgZLhVokuFzH5u8iUeCrAKyTj7CPA
	7myRQ67e0x373b/UrRY6w==
Message-ID: <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
Date: Tue, 17 Jul 2007 10:44:08 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Containers: css_put() dilemma
Cc: dhaval@linux.vnet.ibm.com, "Pavel Emelianov" <xemul@sw.ru>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <469CFF2B.1080702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
	 <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <469CFF2B.1080702@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> That sounds correct. I wonder now if the solution should be some form
> of delegation for deletion of unreferenced containers (HINT: work queue
> or kernel threads).

What a great idea. In fact, that's exactly what the release agent
patch already does.

>
> > Adding a synchronize_rcu in container_diput() guarantees that the
> > container structure won't be freed while someone may still be
> > accessing it.
> >
>
> Do we take rcu_read_lock() in css_put() path or use call_rcu() to
> free the container?

Good point, we ought to add rcu_read_lock() (even though it doesn't
actually do anything on architectures other than alpha, right?)

Using call_rcu to do the container kfree rather than synchronize_rcu()
would be a possible future optimization, yes.

Paul
