Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbXCHOUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbXCHOUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXCHOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:20:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:41460 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXCHOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LRx+7Hp40hebuEh3rj5TGKYwF3mxazThiAQu1HOlLjHPsIdIB0S2POYsGyUNZz7+U8gJz7fMF4pzFSSCvtf4tGo++8XT1HZACpsJ8zsRUpyF7PZnx2UaAtuTzVg0sLQSI+XjqdTKfCiu3p2iCJREjAg3P9HlUtDu/M7MPGBuHu0=
Message-ID: <5c77e7070703080620i3e2a3a64sf9d3121e4f6d382a@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:20:02 +0100
From: "Carsten Otte" <cotte.de@gmail.com>
To: "Martin Drab" <drab@kepler.fjfi.cvut.cz>
Subject: Re: Question about memory mapping mechanism
Cc: hugh@veritas.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> The thing is that I'd like to prevent kernel to swap these pages out,
> because then I may loose some data when they are not available in time
> for the next round.

One think you could do is grab a reference to the pages upfront. When
you stop pushing data out to the userspace, or at least when the file
is released, you need to drop that reference again. You could even do
a kmap_atomic(), which would give you a kernel space mapping. That
way, you avoid copy_to_user for that data.
I am not sure if that's the "proper way", just my $0.02 how I would
try to solve it.

Carsten
