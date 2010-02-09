Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0BINP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:15:57 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:60020 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0BINP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XsWs/0OyFA1hpLKEGJbQY4XvrBii2E4dX20rSBQ9zvjPMX+IPzVA3WHUfLteuaBcgZ
         uDa3Z1FkVGqOs9D8uqR+UAVaAefIvZZY+1eqxkGFJMO7+CKRs5u7fNVGPC6k6EfteHZX
         poFrPDNq7c6W0D7iV+BrQidYwb6YJCVqj2ruo=
MIME-Version: 1.0
In-Reply-To: <20100209130804.GB30014@suse.de>
References: <4B715C55.5090102@gmail.com> <20100209130804.GB30014@suse.de>
From: roel kluin <roel.kluin@gmail.com>
Date: Tue, 9 Feb 2010 14:15:35 +0100
Message-ID: <25e057c01002090515v2f4329aj9220985963bb41d0@mail.gmail.com>
Subject: Re: [PATCH] USB: don't read past config->interface[] if 
	usb_control_msg() fails in usb_reset_configuration()
To: Greg KH <gregkh@suse.de>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 2:08 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Feb 09, 2010 at 02:00:05PM +0100, Roel Kluin wrote:
>> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
>> break occurred, i equals config->desc.bNumInterfaces. so if
>> usb_control_msg() failed then after goto reset_old_alts we read from
>> config->interface[config->desc.bNumInterfaces].
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>
> Have you seen this happen on real hardware?
>
> curious,
>
> greg k-h
>

No, I just found it in the code,

Thanks, Roel
