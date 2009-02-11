Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZBKDcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZBKDcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 22:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZBKDcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 22:32:25 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:27545 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZBKDcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 22:32:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P00M2d03KrDItN0+YTQwHzyxcvhHNIRiYBXo9ZiA2u+lB6HbifyoSLsmFxmw90vRla
         9j6klN81cO5YD1b2muPJoP9WGNmU7Yw4JUCKgmnOsZAYUUp3dLbafAxPI7MUftoh/Urh
         K1/w+ix2JNX043KvxIJoyQ/xjblNaNLJuidYE=
MIME-Version: 1.0
In-Reply-To: <1234283205.3119.64.camel@localhost>
References: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
	 <1233846195.3028.14.camel@localhost>
	 <386072610902052347m5754262bif18339809a00cb9f@mail.gmail.com>
	 <386072610902060000s2e150e4cla19aca70f38b0474@mail.gmail.com>
	 <20090210160451.GD3534@tuxdriver.com>
	 <1234283205.3119.64.camel@localhost>
Date: Wed, 11 Feb 2009 11:32:20 +0800
X-Google-Sender-Auth: c6789bfad0857098
Message-ID: <386072610902101932g6eb837e8iac6c978c67383e41@mail.gmail.com>
Subject: Re: [PATCH] wireless: introduce POWEROF2_BLOCKSIZE_ONLY option
From: Bryan Wu <cooloney@kernel.org>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 12:26 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2009-02-10 at 11:04 -0500, John W. Linville wrote:
>> On Fri, Feb 06, 2009 at 04:00:28PM +0800, Bryan Wu wrote:
>> > On Fri, Feb 6, 2009 at 3:47 PM, Bryan Wu <cooloney@kernel.org> wrote:
>> > > On Thu, Feb 5, 2009 at 11:03 PM, Dan Williams <dcbw@redhat.com> wrote:
>> > >> On Thu, 2009-02-05 at 15:30 +0800, Bryan Wu wrote:
>> > >>> From: Cliff Cai <cliff.cai@analog.com>
>> > >>>
>> > >>> Introduce POWEROF2_BLOCKSIZE_ONLY option for those SD/SDIO host
>> > >>> which only support transferring block with size of power-of-2
>> > >>
>> > >> Is the point here to avoid copying in the controller code?  As with the
>> > >> other patches on libertas-dev, I really dislike adding code to *every
>> > >> SDIO driver* just because the host has certain restrictions.  I'd much
>> > >> rather that the host/controller code became aware of it's own
>> > >> restrictions, and exposed those generically to drivers above it.
>> > >> Without a KConfig option.
>> > >>
>> > >> Seriously.  The host knows what it needs.  The code to handle that
>> > >> should go in the host.
>> > >>
>> > >
>> > > I agree here.
>> > >
>> > >> How about adding a method like "sdio_align_size" that takes the
>> > >> controller's constraints into account?  That seems a lot cleaner than
>> > >> adding #define/KConfig junk to every SDIO driver in the kernel.  One
>> > >> less codepath to test, makes your life and all our lives easier.
>> > >>
>> > >
>> > > So we plan to add method ".sdio_align_size" to SDIO stack.
>> > > And Blackfin host driver will implement this method while others will
>> > > implement this as a dummy function.
>> > >
>> >
>> > sdio_align_size is already in SDIO stack, so we just need to add our
>> > constraints to this function.
>>
>> I'm reading this as "this patch is unnecessary or will be replaced
>> by something better", so I'm dropping it.  If I misread that, feel
>> free to repost...thanks!
>
> Yeah, some patches got posted to the MMC lists that do what this patch
> would do, but do it in a somewhat better manner.
>

Exactly, Cliff will redesign a new patches for MMC/SD stack to fix this.

Thanks
-Bryan
