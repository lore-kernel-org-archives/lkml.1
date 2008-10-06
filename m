Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYJFRPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYJFRPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYJFRO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:14:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38815 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbYJFRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:14:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oKHyVUWpidcIilbfkYMxWmZ9L2vdWzO6cFQxUFAnJgUazszcLRjHVU+nkWqY2tKwB
	gY7+BoSPI5ARFPRjHOvkg==
Message-ID: <6599ad830810061014q5535b5b6kfb53182b3fcc60c8@mail.gmail.com>
Date: Mon, 6 Oct 2008 10:14:42 -0700
From: "Paul Menage" <menage@google.com>
To: righi.andrea@gmail.com
Subject: Re: [PATCH -mm 2/6] introduce struct res_counter_ratelimit
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       "Carl Henrik Lunde" <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       "Divyesh Shah" <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, "Hirokazu Takahashi" <taka@valinux.co.jp>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Marco Innocenti" <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       "Ryo Tsuruta" <ryov@valinux.co.jp>,
       "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E9C637.8030507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com>
	 <6599ad830810051103v1bd6e8d4xd2fcf622558fc7d9@mail.gmail.com>
	 <48E9C637.8030507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2008 at 1:03 AM, Andrea Righi <righi.andrea@gmail.com> wrote:
>> Could you not either:
>>
>> - include these two extra fields in res_counter?
>> - include res_counter as the first field in a res_counter_ratelimit?
>
> The second solution would save some space if the "ratelimit" part is not used.

Having a "policy" field in res_counter seems like it might be reusable
as something for other non-ratelimited res_counters. And even if it's
not, the memory overhead of a couple of extra fields in a res_counter
is trivial compared to the overhead of resource isolation anyway.

So my first approach to this would be just extend res_counter, and
then split them apart later if it turns out that they really do need
mutually incompatible code/handlers.

Paul
