Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZEDRVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZEDRVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEDRVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:21:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:28260 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZEDRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LJNcdZVTv8IVhvAfq9yD/nQfg7bipNvclLiOaC/008CdgthLVOHXDIru8WxxW+uFq2
         vHr+UK6ppCP6UB7AUp+iSX1GwC1AP1nVKli6EpGsTbshk06w5IcIJR3efxvIgGoBksZo
         MCnN9SwRFZmc3Wm3QaZhCWrVBXCpn4a7fEa6I=
MIME-Version: 1.0
In-Reply-To: <20090504145700.GA875@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
	 <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com>
	 <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
	 <20090504113751.GA22603@avionic-design.de>
	 <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
	 <20090504145700.GA875@avionic-design.de>
Date: Mon, 4 May 2009 22:51:21 +0530
Message-ID: <5d5443650905041021n1f709ce1y382440d1285b09ec@mail.gmail.com>
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
From: Trilok Soni <soni.trilok@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Kwangwoo Lee <kwangwoo.lee@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Therry,

On Mon, May 4, 2009 at 8:27 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> * Trilok Soni wrote:
>> Hi Thierry,
>>
>> On Mon, May 4, 2009 at 5:07 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>> > * Kwangwoo Lee wrote:
>> >> Hi Thierry and Trilok,
>> >>
>> >> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> >> > Hi Thierry,
>> >> >
>> >> > I have added linux-omap community. How different is this chip from
>> >> > tsc2007. It looks to me that this chip is not much different from
>> >> > tsc2007 (this is just quick look at the driver). If they
>> >> > are similar please consider using i2c_device_id feature in tsc2007 to
>> >> > accommodate this chip.
>> >>
>> >> I agree with the Trilok's opinion.
>> > [snip]
>> >
>> > I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
>> > finished (it's actually pretty old, I just never got around to submitting
>> > it). However I never got the tsc2007 to work on my platform because it uses
>> > sleeping functions inside the timer handler, which results in an oops right
>> > after the first touchscreen interrupt.
>> >
>> > I guess I could try and fix the tsc2007 properly instead of having a second,
>> > pretty similar driver in the tree.
>> >
>>
>> This could be because of improper locking? If you share a crash we can
>> have look at it.
>
> Attached is a patch that fixes things for me. The problem was that the I2C
> transfers were done in interrupt context which fails for the controller I use
> (PXA270). The attached patch uses a struct work_struct to schedule the I2C
> transfers so they are executed in non-interrupt context.
>
> I've tested the patch on a minimal system with tslib and it work fine with
> ts_calibrate and friends.

Thanks for the patch. It looks good. Let's wait for Kwangwoo Lee to
verify it on his platform. Also please add "tsc2003" entry into
i2c_device_ids so that i2c_board_info can specify the .name as
"tsc2003".

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
