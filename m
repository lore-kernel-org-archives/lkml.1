Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0BIWKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:10:09 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:46161 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0BIWKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:10:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WcyzNpFoq4Kbo4qWzulzH0Ft8OBxnj5uJFkRgFxh0yZtOy/OzDKx5HdNLzga7ikaSG
         JKglfqHje2m7+kJh12xFTFCCw8U7F2CbDKMCAH1tPwsLT8nXsX9UtOeK2EjmTDXR2BZ4
         sR3MQqd9dAm8Gfo45qSx2OEQ+yQTN/ok+eN4M=
MIME-Version: 1.0
In-Reply-To: <20100209220120.GB4607@xanatos>
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org> 
	<4B7186F1.808@gmail.com> <20100209220120.GB4607@xanatos>
From: roel kluin <roel.kluin@gmail.com>
Date: Tue, 9 Feb 2010 23:09:45 +0100
Message-ID: <25e057c01002091409l83a7d7fwd2f7762725f83e50@mail.gmail.com>
Subject: Re: [PATCH] USB: don't read past config->interface[] if 
	usb_control_msg() fails in usb_reset_configuration()
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 11:01 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Tue, Feb 09, 2010 at 05:01:53PM +0100, Roel Kluin wrote:
>> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
>> break occurred, i equals config->desc.bNumInterfaces. so if
>> usb_control_msg() failed then after goto reset_old_alts we read from
>> config->interface[config->desc.bNumInterfaces].
>> We can safely decrement i as well if the break occurred.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> Bah, yes, you're right. :)  Good catch.

Could you please confirm whether this patch is the better or the
other (in this same thread)?

Thanks,
Roel
