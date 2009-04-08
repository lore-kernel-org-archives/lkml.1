Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbZDHN0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbZDHN0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbZDHNZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:25:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:43995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZDHNZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <49DC3F1F.9040306@gawab.com>
References: <49DC3094.5010607@gawab.com> <20090407223828.c9d2cb75.akpm@linux-foundation.org> 
	<49DC3F1F.9040306@gawab.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Apr 2009 06:25:41 -0700
Message-ID: <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a@mail.gmail.com>
Subject: Re: 2.6.30-rc1: OOPS on usb disk insert
To: Justin Madru <jdm64@gawab.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-usb@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 23:07, Justin Madru <jdm64@gawab.com> wrote:
> Andrew Morton wrote:
>> On Tue, 07 Apr 2009 22:05:24 -0700 Justin Madru <jdm64@gawab.com> wrote:

>>> Testing out .30-rc1 and usb devises don't work. I insert my flash disk
>>> and get this oops.

>> The trace appears to be claiming that kernel/async.c:async_new.func is
>> NULL.
>>
>> But it cannot be - it's initialised at compilation time.  Unless
>> something scribbled on it of course.

I've seen async problems with other subsystem too, maybe caused by a
corruption which is fixed by:
  http://patchwork.kernel.org/patch/16776/

  -static void __init acpi_battery_init_async(void *unused, ...
  +static void acpi_battery_init_async(void *unused, ...

Kay
