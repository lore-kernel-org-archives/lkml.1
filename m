Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824AbZG1EEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824AbZG1EEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZG1EEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:04:12 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:53666 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZG1EEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:04:12 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 00:04:12 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ut1iJMBzRCu3+5dOsxqOt09GGQ9Ii8lquF3srlWoi0+tFqHVmWpgjMLiWEUsqg1P2w
         7NaSHDwMHEk/sxfF11rd4kjjBFB6Fq/yUOIIHG7CRTgKOM9boN+NVTP+v3DA02WDeytP
         AhbabRnVT+96czCeUIOtsrB5wjxOUz5MiuggQ=
MIME-Version: 1.0
In-Reply-To: <20090728001041.GG28349@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 27 Jul 2009 20:58:08 -0700
X-Google-Sender-Auth: ef48eaf74bad9a1e
Message-ID: <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to 
	/etc/perfconfig/symbols.skip
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 5:10 PM, Arnaldo Carvalho de
Melo<acme@redhat.com> wrote:
> This also paves the way to add more symbol lists to be filtered out,
> spinlock anyone?

Generally, the way I've found is best to handle things like this is to either:

A. Have a fall-back list to use if the file isn't found, or
B. Start with the fall-back list of symbols to filter, then add to
them via /etc/... and ~/.perf/...

I like approaching things from the 'everything works even in a
broken/hasty installation' point of view, and it's paid off for me.
Sane defaults are a wonderfully useful thing.
