Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYIVNYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYIVNYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYIVNYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:24:03 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:38089 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYIVNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IEqH+Sj41ENO2+BwISOOnBVoGfk+k1drtHkzKj3ld/KR5bQI/K9My5soyuZ2+duaXN
         mSlVNU9JkZ5u2r/A/FPyZFj619cFKysQBtB4ZsXlKFezOocKa69uL25bz6Nx+ECXlR9w
         iSUNPchxPAOI9xSBZlXUMbMUCDbOZP5CR5Yrg=
Message-ID: <9e4733910809220623ka3670f7r8937d248fec4c986@mail.gmail.com>
Date: Mon, 22 Sep 2008 09:23:59 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: netconsole and a serial one
Cc: lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
In-Reply-To: <x498wtkl3lu.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910809211714j5d79592cj162f8be4ecebaa78@mail.gmail.com>
	 <x498wtkl3lu.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 9:19 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> "Jon Smirl" <jonsmirl@gmail.com> writes:
>
>> I have both netconsole and a serial console setup on an embedded
>> system. This is what I need for the boot process.
>>
>> After I'm booted I want to turn off printk() output to the serial
>> console but keep it going to netconsole.
>> I've been googling for an hour, how do I do this?
>>
>> I need to turn off the serial output after boot because serial
>> printk() disables interrupts for up to 1ms which is enough to cause me
>> to lose a lot of other interrupts.
>
> There's no way (that I know of) to do this presently.  However, I think
> David Howells has been working on a patch that reduces the amount of
> time printk spends with IRQs disabled.

I looked into interrupts and printk several years ago. If I recall
correctly printk() prints with interrupts off to ensure stability in
an OOPS situation.  Could serial printk() be changed to disable
interrupts only in the OOPS situation? It's all of the other
non-critical printks that are impacting my system.

-- 
Jon Smirl
jonsmirl@gmail.com
