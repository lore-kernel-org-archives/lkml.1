Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZGHStU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZGHStU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZGHStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:49:13 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:47917 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbZGHStM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iet/mojUZIU7ktqy096fBv/eXtxAZn4LOFv1LIbTtIi3mpWJkZmwDv4WuSOfErva6o
         JzIJmB+pvhM95hFwEOGRZhvvJnR2DUdx2oXWU4v7AqMqF1RHgbKUYyTE/ffDRQsTfGKG
         102of9IEhVQM4MvVXv4hlS8ru37XD2VkPKrjk=
MIME-Version: 1.0
In-Reply-To: <20090704033429.GA1799@ucw.cz>
References: <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> 
	<24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 8 Jul 2009 14:48:51 -0400
Message-ID: <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com>
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating 
	the stack size
To: Pavel Machek <pavel@ucw.cz>
Cc: David Howells <dhowells@redhat.com>, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 23:34, Pavel Machek wrote:
> On Wed 2009-07-08 12:01:40, David Howells wrote:
>> Pavel Machek <pavel@ucw.cz> wrote:
>>
>> > The patch seems wrong to me; loader needs the stack, too, right?
>> >
>> > What about making sure that the loader specifies reasonable stack
>> > size, instead?
>>
>> The loader doesn't need its own stack, unless it _is_ the executable.  It uses
>> the executable's stack.  The problem is that the executable and the loader can
>> both specify the stack size for NOMMU, but which one do we pick, or do we
>> consider both.
>
> Imageine loader needs 64K, while executable only needs 4K. You surely
> want to execute it with 64K stack, because it will not fit into 4K?

i really dont think this is realistic.  there is exactly one ldso that
everyone uses under FDPIC ELF, and it needs a very minuscule stack.
-mike
