Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbYE3ETP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbYE3ETP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760400AbYE3ESR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:18:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:36277 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761137AbYE3ESP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V7P1S7Hv+i054fxqvtftkTi2DQ1T/AgGbieJI0zR63MSpP3KaSMjh2KNZk8W8UAgDxDtkkB4VZASq+p+VEuDqovDnVS3KCqkiE0Tmegy/Vn8YzjkTdU02ASi0N+BUebUj03fbM84T1YH/PLkGtdUfJ5ePoB3k4CyKnwDQRua3MA=
Message-ID: <8bd0f97a0805292118g40a3f88fmd929f1c39c839190@mail.gmail.com>
Date: Fri, 30 May 2008 00:18:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Cc: "David Howells" <dhowells@redhat.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805291428240.7562@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2874.1211980355@redhat.com> <24762.1211983758@redhat.com>
	 <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
	 <7613.1211996335@redhat.com>
	 <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
	 <29553.1212066208@redhat.com>
	 <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
	 <Pine.LNX.4.64.0805291329270.7207@schroedinger.engr.sgi.com>
	 <8bd0f97a0805291351t43ea6d2eue1cdde531aa2fc2c@mail.gmail.com>
	 <Pine.LNX.4.64.0805291428240.7562@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 5:29 PM, Christoph Lameter wrote:
> On Thu, 29 May 2008, Mike Frysinger wrote:
>> > You should not have to do this. This is the default alignment that also
>> > SLOB needs to follow. We need to align structures correctly for access to
>> > long long's.
>>
>> are you saying that slob is broken ?  i see in mm/slob.c:
>> #ifndef ARCH_KMALLOC_MINALIGN
>> #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
>> #endif
>
> It should be long long instead.
>
> SLUB:
>
> #ifndef ARCH_KMALLOC_MINALIGN
> #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> #endif
>
> SLAB:
>
> #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

will you post a patch to do that (and ideally delete all of the
occurrences in asm-*/ where the minalign is defined to 8) ?
-mike
