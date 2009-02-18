Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZBRPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZBRPpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZBRPpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:45:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:35542 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZBRPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <20090218152913.GA26448@suse.de>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <20090218152913.GA26448@suse.de>
Date: Wed, 18 Feb 2009 16:45:08 +0100
Message-ID: <ac3eb2510902180745v2886ae31s2d7faeb2faedab6e@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 16:29, Greg KH <gregkh@suse.de> wrote:
> On Wed, Feb 18, 2009 at 08:11:34AM -0700, Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> I find myself using the pattern of device_add_attributes() and
>> device_remove_attributes() frequently in my drivers.  Rather than
>> reinventing the wheel every time, I'm floating this patch to export
>> the symbols to see how it is received.  If this looks okay then I'll
>> rework my drivers and post additional patches to use these functions.
>
> No objection from me, as long as the symbols are EXPORT_SYMBOL_GPL(),
> like the rest of the driver core.  Is that ok with you?

These functions used outside the core create attributes after the
uevent is sent, and userspace will not see these files at event time.
This is in most cases a pretty broken behavior. Is that the expected
behavior in your drivers?

Thanks,
Kay
