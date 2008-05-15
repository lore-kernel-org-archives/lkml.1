Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYEOIKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYEOIKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYEOIJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:09:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:5332 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYEOIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sISWHPYqryecV7d0GeF5u4dKcu6tkxkmky6zyLnADNIEXFS3HaK9U282iTG38TG0yazb7wnGdncsT2M6Dgg85aK2/9dIxa6pCpyBgCzFCEHwKyzdh8bQsY9WEP8Dh/Ve0uQ7BStOlhf3iWFLGM9MO7cPcdce5RZGoGW5dNeWCHQ=
Message-ID: <386072610805150109t112115abq9a288b64288b1b1c@mail.gmail.com>
Date: Thu, 15 May 2008 16:09:47 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Jie Zhang" <jie.zhang@analog.com>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Cc: "Oliver Neukum" <oliver@neukum.org>, harvey.harrison@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <482BEE57.6040704@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
	 <200805150940.34516.oliver@neukum.org> <482BEE57.6040704@analog.com>
X-Google-Sender-Auth: d17585c99d3f58fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 4:03 PM, Jie Zhang <jie.zhang@analog.com> wrote:
> Oliver Neukum wrote:
>>
>> Am Donnerstag 15 Mai 2008 08:19:24 schrieb Bryan Wu:
>>>
>>> --- a/drivers/usb/host/uhci-hub.c
>>> +++ b/drivers/usb/host/uhci-hub.c
>>> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16
>>> typeReq, u16 wValue,
>>>        switch (typeReq) {
>>>          case GetHubStatus:
>>> -               *(__le32 *)buf = cpu_to_le32(0);
>>> +               put_unaligned_le32(0, buf);
>>
>> What is supposed to make all these changes a good idea?
>>
> Since buf might not be 4-byte aligned.
>

And this change follows Harvey Harrison's patch's style:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5abdeafedf722b0f3f357f4a23089a686b1b80d

-Bryan
