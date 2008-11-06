Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYKFB1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYKFB1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYKFB1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:27:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYKFB1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:27:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=Ti95dY3hGzwtv6Ck3O55JqIIT9P2Tk6/Aa7xCaSwmmw6aZzxB5PP3yoLYiF+f5kSm
	/vl+/fYEaHByN3d6PJGTg==
MIME-Version: 1.0
In-Reply-To: <20081105170748.0e7dac89.akpm@linux-foundation.org>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
	 <20081101022128.3f8a535c.akpm@linux-foundation.org>
	 <1786ab030811051656r7cc09fcakbf485c3b0663757@mail.gmail.com>
	 <20081105170748.0e7dac89.akpm@linux-foundation.org>
Date: Wed, 5 Nov 2008 17:27:08 -0800
Message-ID: <1786ab030811051727w73168a3eq64939567826e76a9@mail.gmail.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
From: Chad Talbott <ctalbott@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 5:07 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 5 Nov 2008 16:56:54 -0800
> Chad Talbott <ctalbott@google.com> wrote:
>> So in the new world, an application should call sync_file_range
>> (solving my problem by including metadata) to initiate writeout, and
>> then call posix_fadvise(DONTNEED) to drop the pages from page cache?
>> I think this would work for me.
>
> That would work.
>
> Although Nick is threatening to make
> sync_file_range(SYNC_FILE_RANGE_WRITE) all slow by using WB_SYNC_ALL,
> probably unnecessarily, ho hum.

Boo!  That will drive users (me at least) running back to
posix_fadvise(DONTNEED) for the non-blocking-writeback-inducing side
effect.

Chad
