Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbZKDFhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbZKDFhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZKDFhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:37:05 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59154 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZKDFhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GS+O85+QUFhAxDVyKpeWmP+KfaFKraaWIdVb7SLm40cXbmLcbsUM7CEGXu5tze1oy+
         2MwbouiNLVbo4iUSblUAKZBT39E6GSRhk8jDaE+kPAi+CtnpgbEYGWkTpy6rD2k2kllC
         PFFHQnvCDPKd1Y9paHj1YJlLuFYgL+VFIOyps=
MIME-Version: 1.0
In-Reply-To: <C86899CCB10A6C4E93D5978DCB232D4B0D754B62@GDCMX01.igglobal.com>
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com> 
	<4AEE63E2.9010003@redhat.com> <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com> 
	<C86899CCB10A6C4E93D5978DCB232D4B0D754B62@GDCMX01.igglobal.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 4 Nov 2009 00:36:48 -0500
Message-ID: <3e8340490911032136x56696cc3u3b6f3b1e5d132324@mail.gmail.com>
Subject: Re: why kernel implement "udelay" by cpu instructions?
To: Rajat Jain <Rajat.Jain@infogain.com>
Cc: loody <miloody@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org,
       Kernel Newbies <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 12:01 AM, Rajat Jain <Rajat.Jain@infogain.com> wrote:
> Hi,
>
>> I find something interesting; kernel has msleep, but it
>> doesn't have usleep.
>> Does that mean the minimum time kernel can react is msecond
>> instead of usecond?
>> so if  users want to count useconds, they have to do the busy waiting,
>> execute some looping assembly instructions?
>
> You are roughly right. If you don't want to busy loop (udelay / mdelay), then you will have to sleep. The granularity of this sleep depends on how frequently the timer interrupt ticks (HZ). Thus if HZ is 1000, then you cannot sleep for a period less than 1 msec.

I thought hrtimers allow higher-precision wakeups these days?
Of course, if you only want to sleep for a few microseconds, the
context switch might take longer than you want to sleep...
