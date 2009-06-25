Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZFYGcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZFYGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZFYGcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:32:09 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59851 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZFYGcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fJ7/DBHREg1PTXFKLVHQHXHKelYlvkUT8dqMgGJ4oBwXsP2v4n0UNUFcp8TbC+7N4r
         BEIFXET9NPCFdZHMLHQkY7VVNjxqjuWTL6D/nAa2XisjrgrxpQ5ui4xkzmQp4sHI3U4M
         HyIf9RCUFHH2QDqT5gIPBRQloznYktNMPtAvE=
MIME-Version: 1.0
In-Reply-To: <20090624174700.GI14121@shareable.org>
References: <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com>
	 <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz>
	 <4A3FC84A.6060608@gmail.com> <20090622204031.GA24236@elf.ucw.cz>
	 <4A3FFC89.4070006@am.sony.com> <20090622215753.GA25434@elf.ucw.cz>
	 <4A4119DB.4030203@gmail.com> <20090623182941.GA2045@elf.ucw.cz>
	 <20090624174700.GI14121@shareable.org>
Date: Thu, 25 Jun 2009 08:32:08 +0200
Message-ID: <2ea1731b0906242332n305a8ebbgf37b259171741ea8@mail.gmail.com>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Pavel Machek <pavel@ucw.cz>, Tim Bird <tim.bird@am.sony.com>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/24 Jamie Lokier <jamie@shareable.org>:
> Pavel Machek wrote:
>> On Tue 2009-06-23 20:07:23, Marco wrote:
>> > You are talked about journaling. This schema works well for a disk, but
>> > what about a piece of ram? What about a crazy kernel that write in that
>> > area for a bug? Do you remember for example the e1000e bug? It's not
>>
>> I believe you need both journaling *and* write protection. How do you
>> handle power fault while writing data?
>
> I think this is basically right.
>
> write protection for the crazy kernels, and journalling for
> powerfail/crash during updates.
>
> Journalling can be extremely simple.  It can be just one memory block
> at a fixed location, double-buffering all writes.
>
> Pramfs already has checksums, which makes that easier.  You just write
> to the buffer area first, with checksum, then write to the final area.
> Mount looks at the buffer area, and if the checksum is fine, copies
> the contents to the destination block.
>
> That's all it takes to be resistant against power failures and crashes
> during writes.  Probably <100 lines of code.
>
> -- Jamie
>

It seems a reasonable request.

Marco
