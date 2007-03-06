Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXCFMo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXCFMo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbXCFMo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:44:28 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:35712 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbXCFMo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BhFi6YwqFc4F/Sve+2hIBwbgXc+kaiDLHotuguyyx21nucIf7IrSskeOC4fFS0vZt9DaeFqMet4JI/3wO6dvNrWMBmN5PeHLUPQekvzx4EhLptT8d/0+nfOqjaUiLU/nVlov0NVJrgB8kxbXmMztr6hfz2Y53KzBiNjNZ6PYK7U=
Message-ID: <45ED6221.5090003@gmail.com>
Date: Tue, 06 Mar 2007 21:44:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use a zero-size array in the struct devres
References: <20070306095241.28180.76390.stgit@localhost.localdomain>
In-Reply-To: <20070306095241.28180.76390.stgit@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Catalin.

Catalin Marinas wrote:
> Commit 9ac7849e35f705830f7b016ff272b0ff1f7ff759 adds the devres
> structure containing a flexible unsigned long long array, with a
> comment about the guaranteed alignment. According to the gcc manual,
> flexible arrays are considered incomplete types and it is an error to
> ask for their alignment. This patch makes data[] a zero-size array.

The gcc manual says nothing about alignment.  What it says is sizeof()
doesn't work.  If flexible array doesn't honor the alignment of the
declared type, it would be useless for its designed purpose of
supporting *array* of dynamically-determined length.

> I came across this when trying to build kmemleak as the modified
> container_of macro tries to get the size of the devres.data member and
> sizeof cannot be applied to incomplete types.

If kmemleak's container_of cannot deal with the current struct devres,
it means it can't deal with flexible arrays at all.  Flexible array
being the standard as opposed to 0 size array gcc extension, I guess a
lot of people would prefer flexible array.

It would be best if kmemleak's container_of can be modified to work with
flexible arrays.  If that's not possible, I guess it needs wider
discussion to determine whether to ditch flexible array for kmemleak.

Thanks.

-- 
tejun
