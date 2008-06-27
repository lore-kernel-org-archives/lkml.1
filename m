Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYF0WF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYF0WF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYF0WFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:05:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4723 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYF0WFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XHzR87RNQ+Qmr7YZdWgH79eHdl6JBOMtpBvr+p/Uf6iLiXBn+qaU86PHza3jlafU6K
         mBN5gyvfzPw0w4OBSqwLngFDqsBBKIRngP2YBxznvFERy7sY66rQwM+0LxrAGKmHanQ1
         09+2wrswEVaNV9CMDESZWkqu05AJUOCLHYbeM=
Message-ID: <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
Date: Fri, 27 Jun 2008 15:05:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214534894.10865.6.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5RM6bfq027924

On Thu, Jun 26, 2008 at 7:48 PM, Huang, Ying <ying.huang@intel.com> wrote:> On Thu, 2008-06-26 at 19:22 -0700, Yinghai Lu wrote:>> On Thu, Jun 26, 2008 at 2:47 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:>> > On Thu, Jun 26, 2008 at 12:48 AM, Huang, Ying <ying.huang@intel.com> wrote:>> >> On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:>> >> [...]>> >>> >                if (pfn >= limit_pfn)>> >>> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt>> >>> >                return 0;>> >>> >>> >>> >        addr = round_down(start + size - sizet, align);>> >>> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);>> >>> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);>> >>>>> >>> this line is not needed.>> >>>> >> Why? Memory reserved by early_rserved_e820 should not be saved during>> >> hibernation? shoudl not be saved by kdump?>> >>>> Can you tell me why this line is not needed?>> [...]>> some like the attach patch...>>>> you still can merge parse_setup_data parse_e820_ext>> also entries in parse_e820_ext is not initialized..., __copy_e820_map>> will do nothing.>> ï»¿OK. Because some E820 entries are available after parse_setup_data(),> it is better to call reserve_setup_data() after calling> parse_setup_data() if update_e820_range() is used instead of> reserve_early().
please modify it and test on your platforms then submit to Ingo..
Thanks
YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
