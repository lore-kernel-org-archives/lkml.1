Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZANKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZANKeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZANKeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:34:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:48743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZANKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:34:01 -0500
MIME-Version: 1.0
In-Reply-To: <1231926744.11907.12.camel@skunk>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel>
	 <1231926744.11907.12.camel@skunk>
Date: Wed, 14 Jan 2009 11:34:00 +0100
Message-ID: <ac3eb2510901140234m29ca516bocd0e7dd997122a7b@mail.gmail.com>
Subject: Re: linux kernel without file system
From: Kay Sievers <kay.sievers@vrfy.org>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Philippe De Muyter <phdm@macqel.be>, Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:52, Xavier Bestel <xavier.bestel@free.fr> wrote:
> On Wed, 2009-01-14 at 10:34 +0100, Philippe De Muyter wrote:
>> On Wed, Jan 14, 2009 at 09:46:48AM +0100, Tomasz Chmielewski wrote:
>> >> I need to design a very small embedded system that must only control
>> >> one ethernet port and two serial lines and must fit in a very small flash
>> >> memory.  So I thought about replacing the call to /etc/init by my
>> >> application
>> >> program and removing all the file-system part of linux.
>> >> Is that doable ?
>> >> Is there a 'standard' way of doing that ?
>> >> The first problem I see is accessing my serial lines.  How could I do that
>> >> without using open("/dev/ttySx"), which requires a file system ?
>> >> Is there a way to access devices that does not require a file-system ?
>> >
>> > You could put everything in initramfs (and embed it in the kernel).
>>
>> Actually, I was thinking about reducing the footprint of my kernel by
>> removing all the fs-related system calls, so the problem is not where
>> the file-system is, but how to access (serial) devices without giving their
>> "/dev/..." name.
>
> You can still mount sysfs somewhere and access the device nodes from
> there.

There are no device nodes in sysfs to talk to the device, only
attributes, which are mostly plain small text files. For some devices
there are a few writable and mappable files which can change the
device's state, but that's nothing like a device node.

Kay
