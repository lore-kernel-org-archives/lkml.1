Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKFG3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKFG3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYKFG27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:28:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:49233 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYKFG27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:28:59 -0500
Message-ID: <ac3eb2510811052228o305b432cp2df9d311f103fc92@mail.gmail.com>
Date: Thu, 6 Nov 2008 07:28:56 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: virtio: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <200811061445.12050.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225393822.21973.39.camel@nga.site>
	 <200811061445.12050.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 04:45, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 31 October 2008 06:10:22 Kay Sievers wrote:
>> This patch is part of a larger patch series which will remove
>> the "char bus_id[20]" name string from struct device. The device
>> name is managed in the kobject anyway, and without any size
>> limitation, and just needlessly copied into "struct device".
>
> OK, I've applied this patch.

Thanks!

> I'm curious how you're going to handle out-of-memory conditions?

If the name can't be set, the following call to device_register() will
fail, and should be handled by the caller. Just like today when we
allocate the kobject name in device_register(). After the core has
switched over, the name allocation will only happen a few lines
earlier, it should not behave different otherwise. Is that what you
mean?

Thanks,
Kay
