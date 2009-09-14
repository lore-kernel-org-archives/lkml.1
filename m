Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZINWTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZINWTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbZINWTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:19:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZINWTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:19:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=LtEYrSrn6HP+DGAt4F+zOOot1pNrofsBJdjCqLu3symULIzg4oQ+ncYekeQfb2RyW
	9Chk7ecClahvrV4KI4K3w==
MIME-Version: 1.0
In-Reply-To: <1252965980.11643.261.camel@desktop>
References: <20090914215855.GC11667@elf.ucw.cz>
	 <1252965980.11643.261.camel@desktop>
Date: Mon, 14 Sep 2009 15:19:11 -0700
Message-ID: <a55d774e0909141519i752eca3dp7ab848e1c1154530@mail.gmail.com>
Subject: Re: [patch 3/6] add pmem driver
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>, arve@android.com,
       kernel list <linux-kernel@vger.kernel.org>,
       Iliyan Malchev <malchev@google.com>,
       Petri Gynther <pgynther@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 3:06 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Mon, 2009-09-14 at 23:58 +0200, Pavel Machek wrote:
>>
>> This adds android pmem driver, one of dependencies of camera driver.
>
> I wouldn't even both with this one .. There's no way it could ever go
> into mainline .. According to the android developers the camera , and
> the frame buffer driver should work without it anyway..

The latest camera driver should work without pmem (or be fixable to do
so -- I forget if that's done yet).

The framebuffer itself does not need pmem, but pmem is used heavily by
the android userspace on dream/magic for hardware compositable
surfaces (since the 2d compositor requires physically contiguous
memory).

Is there a general linux kernel solution for managing large (1-8MB+)
chunks of physically contiguous memory that needs to be shared between
kernel and userspace for media operations?  This is a very common
problem with these SoCs -- the a/v subsystem and/or GPU don't have
scatter/gather or MMU support and as a result we need to carve out
memory for their use and provide some way for userspace to manipulate
it.

Brian
