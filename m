Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYE2UwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYE2UwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYE2Uvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:51:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:27606 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYE2Uvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZvWz8/NUjW8MH1Ghr/3QS2RQYdoDdCQWmp6uaUajqZjrOnSi02vqpY9V3vajkulGMD5NW7U8MEEvWhZeHxu2hFAWZ6O0hLGrdasCPwkYaPX2OsKOQZpR9xPd9i4oj+7VgeFvLwDl975mYkaKfgS5jq1BEcuBrPjLN/Vi1XuMo7o=
Message-ID: <8bd0f97a0805291351t43ea6d2eue1cdde531aa2fc2c@mail.gmail.com>
Date: Thu, 29 May 2008 16:51:50 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Cc: "David Howells" <dhowells@redhat.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805291329270.7207@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2874.1211980355@redhat.com>
	 <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
	 <24762.1211983758@redhat.com>
	 <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
	 <7613.1211996335@redhat.com>
	 <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
	 <29553.1212066208@redhat.com>
	 <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
	 <Pine.LNX.4.64.0805291329270.7207@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 4:30 PM, Christoph Lameter wrote:
> On Thu, 29 May 2008, Mike Frysinger wrote:
>> On Thu, May 29, 2008 at 9:03 AM, David Howells wrote:
>> > Mike Frysinger <vapier.adi@gmail.com> wrote:
>> >> > I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.
>> >>
>> >> what was the change exactly ?
>> >
>> > The attached patch.
>> >
>> > diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
>> > +#define        ARCH_KMALLOC_MINALIGN           8
>> > +#define        ARCH_SLAB_MINALIGN              8
>>
>> yeah, we were already doing that ... and the problem we had that i
>> referred to seems to be merged already into mainline, so you shouldnt
>> run into it unless you're using older kernel versions
>
> You should not have to do this. This is the default alignment that also
> SLOB needs to follow. We need to align structures correctly for access to
> long long's.

are you saying that slob is broken ?  i see in mm/slob.c:
#ifndef ARCH_KMALLOC_MINALIGN
#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
#endif
-mike
