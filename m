Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbYF3Wxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbYF3Wxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763469AbYF3WxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:53:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:6481 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763460AbYF3WxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YrS67PmLK6t7zK2ZTevF/tu5GFuSrM7825vruza4tgT2xy168INS0k/Glp58A3Xn2p
         sq5d6ctTx+R1ONYx7Ea91rxvW5EW8yPUskcA/w0EZW9AUhSGY1gMKu/xWyX7ggrdVqpI
         XdJfnw1uhggOXZCKKQm1SfGahamH0IV9alhRg=
Message-ID: <86802c440806301553y240b020bh9dc448e8085fe60d@mail.gmail.com>
Date: Mon, 30 Jun 2008 15:53:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080630191628.GA15366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
	 <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
	 <1214809434.2887.8.camel@caritas-dev.intel.com>
	 <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com>
	 <1214812303.3187.10.camel@caritas-dev.intel.com>
	 <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com>
	 <1214818706.23677.8.camel@caritas-dev.intel.com>
	 <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com>
	 <20080630191628.GA15366@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 12:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > For find_e820_area, this is safe enough. But what about conflict
>> > between setup_data and ebda or ramdisk?
>>
>> can you have setup_data and ebda at the same time?
>>
>> setup_data and ramdisk should be ok, because bootloader is supposed to
>> make them not to be conflicts.
>
> the more sanity checks we do before relying on some crutial data, the
> better. It's easier to panic or sanitize data in some structured way and
> complain about it in the syslog than to let things get corrupted. Boot
> loaders are ... not unknown to be have bugs too, at times.

to address Ying's concern, we could let reserve_setup_data
call reserve_early in addition to e820_update_range...

reserve_early will panic if RAMDISK overlap efi setup_data...

YH
