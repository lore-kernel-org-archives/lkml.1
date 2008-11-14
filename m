Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYKNTXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYKNTXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKNTXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:23:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:48198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYKNTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:23:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BbGmkr2fdm6zN98p2JGBE044B1uz6A6pNAEvbAzaUr0GGbFclNRaxA1Zaso7eWtx/E
         hfEKJqlXT1cGrDrA5LLylZpEM5bxitgSTPIf86RwuvECAGKCujfXIxRbxqyOBtM9/F9e
         oNTG6cOWJOqRU4sueiOkgnuAd40yh/wUq0bHo=
Message-ID: <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
Date: Fri, 14 Nov 2008 14:15:10 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids are __le16
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1226689669.5483.36.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
X-Google-Sender-Auth: 35b7d25bd9beaf78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 2:07 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Fri, 2008-11-14 at 14:05 -0500, Michael Krufky wrote:
>> Wouldn't it be nicer to just switch on
>> cpu_to_le16(udev->descriptor.idVendor) ?  This would be a 1-line change,
>> compile to a smaller footprint, and be easier to read.
>>
>> Personally, I prefer to try to avoid duplicating code in places where a
>> single operation may occur centrally.
>
> On a little-endian arch it makes no difference obviously, but on a
> big-endian arch it's the difference between compile-time and runtime
> byteswapping.
>

Its not my driver, but I think that doing the operation on the switch
is prettier than doing it on each case statement.  Also, it would
avoid future bugs, if somebody decides to add new cases to the switch
block.

-Mike
