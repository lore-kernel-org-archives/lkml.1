Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXH2WUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXH2WUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXH2WU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:20:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39714 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXH2WU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:20:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Xa2GBQTz4q4+uPTMeFlHvcQLjmOdtlzaHwFshF6OrIxM+MdHgi0BajwrCnpWdCEv0
	OP9h9bVI93Su8g6zDq42A==
Message-ID: <6599ad830708291520t2bc9ea20m2bdcd9e042b3a423@mail.gmail.com>
Date: Wed, 29 Aug 2007 15:20:09 -0700
From: "Paul Menage" <menage@google.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
Subject: Re: [-mm PATCH] Memory controller improve user interface
Cc: balbir@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "David Rientjes" <rientjes@google.com>,
       "Linux Containers" <containers@lists.osdl.org>
In-Reply-To: <1188425894.28903.140.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
	 <1188413148.28903.113.camel@localhost>
	 <46D5ED5C.9030405@linux.vnet.ibm.com>
	 <1188425894.28903.140.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Dave Hansen <haveblue@us.ibm.com> wrote:
> On Thu, 2007-08-30 at 03:34 +0530, Balbir Singh wrote:
> > I've thought about this before. The problem is that a user could
> > set his limit to 10000 bytes, but would then see the usage and
> > limit round to the closest page boundary. This can be confusing
> > to a user.
>
> True, but we're lying if we allow a user to set their limit there,
> because we can't actually enforce a limit at 8,192 bytes vs 10,000.
> They're the same limit as far as the kernel is concerned.
>
> Why not just -EINVAL if the value isn't page-aligned?  There are plenty
> of interfaces in the kernel that require userspace to know the page
> size, so this shouldn't be too difficult.

I'd argue that having the user's specified limit be truncated to the
page size is less confusing than giving an EINVAL if it's not page
aligned.

Paul
