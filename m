Return-Path: <linux-kernel-owner+w=401wt.eu-S1765661AbZFOSng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765661AbZFOSng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765278AbZFOSn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:43:26 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765123AbZFOSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:43:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DQf/wC4GEdV8+eBxKLj6YdpDS7VLO14YfkN+h4cpfnklry+w/KEoH4E+++ZBU3zjH
	Q6KeOgOJnkcB0SNred35g==
MIME-Version: 1.0
In-Reply-To: <20090615183433.GB10490@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <1245033557-10968-3-git-send-email-swetland@google.com>
	 <20090615132018.GA14555@elf.ucw.cz>
	 <a55d774e0906151130x3892346fx5aa1f62c387b2090@mail.gmail.com>
	 <20090615183433.GB10490@elf.ucw.cz>
Date: Mon, 15 Jun 2009 11:43:23 -0700
Message-ID: <a55d774e0906151143r4181654cje37a9bbcfe092cec@mail.gmail.com>
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL) 
	configurable
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:34 AM, Pavel Machek<pavel@ucw.cz> wrote:
>> > ...and those that do, have it at fixed uart, no?
>>
>> Well, I'd like to support the SoC generally, not just Dream -- it's
>> used in a bunch of different devices, and there's nothing that forces
>> you to use UART3 everywhere (I certainly have seen some 7k hardware
>> that uses UART1 as the debug serial port).
>
> Aha, ok, I guess that should go to the changelog. (Nice bonus would be
> if it was automatically/correctly set up when user selects machine
> type... Actually, how does that work if you support few boards with
> same kernel...?)

At this point a kernel for multiple boards with different DEBUG_LL
uarts doesn't work correctly -- I'm not sure this could be done
without making the debug macro code, etc, a lot messier (since it has
to write to the physical uart address in early boot and I believe that
happens before the machine type is determined, though maybe I'm
wrong).

For a shipping kernel that's just including the serial driver and not
the DEBUG_LL stuff, it doesn't have a problem (since the uart is
configured from the board file a bit later in boot).

Brian
