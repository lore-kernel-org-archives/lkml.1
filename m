Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0BPIMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:12:31 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:57741 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab0BPIM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uBinAlyIfsXukXMoARaVwpSYAuDhx8iRm382GZJYCYIKtcbWEveOwbCFZr3EUnuYOT
         dpoHIKZ2TQOYx6C5gqkLeCt6VT6GT5nUPEYYx6KejaGYKAJgRs4hiQLGOmTCHttP5RdG
         vblXIc6qcQZaKb4Kv5psmZRB3//ClNBNhrL5w=
MIME-Version: 1.0
In-Reply-To: <20100216011041.GB4889@linux-sh.org>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org> 
	<20100216011041.GB4889@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 16 Feb 2010 03:12:09 -0500
Message-ID: <8bd0f97a1002160012x2736f2b1r1ea4e57c41cf7fbb@mail.gmail.com>
Subject: Re: [PATCH] ptrace: unify FDPIC implementations
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 20:10, Paul Mundt wrote:
> On Mon, Feb 15, 2010 at 07:30:29PM -0500, Mike Frysinger wrote:
>> The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
>> their arch handlers (since they were probably copied & pasted).  Since
>> these ptrace interfaces are an arch independent aspect of the FDPIC code,
>> unify them in the common ptrace code so new FDPIC ports don't need to copy
>> and paste this fundamental stuff yet again.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> Acked-by: Roland McGrath <roland@redhat.com>
>> Acked-by: David Howells <dhowells@redhat.com>
>> Acked-by: Paul Mundt <lethal@linux-sh.org>
>
> Just to follow up on this, this code obviously expects consistent entries
> in mm_context_t. Presently include/asm-generic/mmu.h is aimed at nommu,
> so it would probably be worthwhile stubbing in the FDPIC loadmap entries
> there to make things easier for future ports.

probably be a good idea.  for FDPIC in general, the header also needs
"stack_start".
-mike
