Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYJEWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYJEWxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYJEWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:53:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:53790 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYJEWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:53:30 -0400
Message-ID: <f488382f0810051553t32a24972ma7baa92605f43772@mail.gmail.com>
Date: Sun, 5 Oct 2008 15:53:28 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, drzeus@drzeus.cx
In-Reply-To: <20081005142819.GB12047@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001083532.GE31009@elte.hu>
	 <1222851025-30619-1-git-send-email-steven@uplinklabs.net>
	 <20081005142819.GB12047@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 7:28 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Oct 01, 2008 at 01:50:25AM -0700, Steven Noonan wrote:
>> The variable 'scratch' is always initialized before it's used. The
>> conditional which is responsible for initialization of 'scratch' will
>> always evaluate 'true' when the first loop iteration occurs, and thus,
>> it's properly initialized. GCC doesn't see this, of course, so using
>> the uninitialized_var() macro seems to work for silencing this case.
>>
>> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
>> ---
>>  drivers/mmc/host/sdhci.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index e3a8133..6257677 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
>>  {
>>       unsigned long flags;
>>       size_t blksize, len, chunk;
>> -     u32 scratch;
>> +     u32 uninitialized_var(scratch);
>>...
>
> With which gcc version?
>
> I'm not getting this warning with gcc 4.3, and IMHO it doesn't make
> sense to clutter the source code with such workarounds for older gcc
> versions (we officially support 6 years old compilers, and warning-free
> compilations with all of them are not reasonably possible).
>
> cu
> Adrian

I've seen it on GCC 4.1 and 4.2. Since lots of distributions still
haven't marked GCC >4.1 stable, it makes sense to me to kill warnings
for GCC 4.1 and above. I don't know of any current distribution
releases using less than GCC 4.1 at the moment.

- Steven
