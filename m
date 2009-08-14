Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbZHNR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbZHNR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbZHNR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:56:18 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:52921 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbZHNR4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=b3yGUX12FZ+ngo8d5ztFDUkAUjjBd1r9VV0TAEhcFJrBMjB7nOeMBwIupOpL3k+3eK
         s38ke6Q9n253tMqzaZwnhab166wVAVDrLSnTWR8t0Zmk6W+GhMwMtiBQhWoFCg5T23eX
         P0PaNe4ePlbW4z/SnyqfGYYMgQLT+VQov1OrQ=
MIME-Version: 1.0
In-Reply-To: <20090724163814.08c7eee3.akpm@linux-foundation.org>
References: <20090723152647.D9391722@kernel>
	 <20090724163814.08c7eee3.akpm@linux-foundation.org>
Date: Fri, 14 Aug 2009 10:56:18 -0700
X-Google-Sender-Auth: 2e9243b10bc937b2
Message-ID: <e9c3a7c20908141056o32ce1204k6751b43271aa88ab@mail.gmail.com>
Subject: Re: [RFC][PATCH] flexible array implementation v4
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, vda.linux@googlemail.com, mikew@google.com,
       lizf@cn.fujitsu.com, xiyou.wangcong@gmail.com,
       kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, bblum@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 4:38 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Thu, 23 Jul 2009 08:26:47 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>
>>  linux-2.6.git-dave/include/linux/flex_array.h |   46 ++++
>>  linux-2.6.git-dave/lib/Makefile               |    2
>>  linux-2.6.git-dave/lib/flex_array.c           |  269 ++++++++++++++++++++++++++
>
> I haven't looked at this lately but I merged it.
>
> As it's obviously non-injurious, we could slip it into 2.6.31 for
> convenience's sake but without any callers that's just runtime bloat.
> So I guess we wait for some additional callers to come along and prove
> its worth.
>

I am considering using this for managing the descriptor ring in a
device driver, but I am concerned with the overhead of the divides.
Would it be acceptable to round the element size to the next
power-of-2 value so we can replace all the divides with shifts?

Thanks,
Dan
