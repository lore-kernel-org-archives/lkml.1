Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZDPHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZDPHSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZDPHSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:18:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:60409 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZDPHSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=meqGVm9k2ppTaRzxgCQ6jfRKJP7QaYdT/9eckC0h6YZEmjpEuP1fzOnAr586lu7+3u
         pKBYsDg/J+K86yEfpjaL1r7fDBIVc1tkeMHRjPrAquTFtB/HhUDJNYEo24eXl9CNoout
         7ODWGh8QhGc64EIgk0a/v5zo0xksmhDjxMWI4=
MIME-Version: 1.0
In-Reply-To: <49E6D8FE.80908@xenontk.org>
References: <49E6D8FE.80908@xenontk.org>
Date: Thu, 16 Apr 2009 00:18:06 -0700
Message-ID: <86802c440904160018j5c4842d8t92742b6a1b2e4514@mail.gmail.com>
Subject: Re: X freezes intermittently with 2.6.29.1
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: davidjon@xenontk.org
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 12:06 AM, David John <davidjon@xenontk.org> wrote:
> Hi All,
>
> With 2.6.29.1 (stock kernel), on my Dell Inspiron 1545, X freezes for
> 15-20 seconds at a time randomly every 10 seconds or so making it
> unusable. Currently, I use the 2.6.29.1-54.fc11.x86_64 kernel that comes
> with Fedora 11 Beta which has the same problem but only when X is left
> idle for a period of time. The kernel log is overrun by messages of the
> type:
>
> X:2802 freeing invalid memtype e4b42000-e4b43000
> X:2802 freeing invalid memtype e4b43000-e4b44000
> X:2802 freeing invalid memtype e4b44000-e4b45000

can you try tip?
http://people.redhat.com/mingo/tip.git/readme.txt

it seems include one patch for that.

>
> This I believe is related to this:
>
> mtrr: type mismatch for e0000000,10000000 old: write-back new:
> write-combining
> [drm] MTRR allocation failed.  Graphics performance may suffer.
>
> The MTRR setup is below:
> reg00: base=0x000000000 (    0MB), size=32768MB, count=1: write-back
> reg01: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
> reg02: base=0x07dc00000 ( 2012MB), size=    4MB, count=1: uncachable
> reg03: base=0x07e000000 ( 2016MB), size=   32MB, count=1: uncachable
>
> I think the first entry is bogus. Both kernels come with the
> MTRR sanitize option enabled but the code is unable to find an
> optimal value. Is there any way to correct this? What values for
> mtrr_gran_size and mtrr_chunk_size would be appropriate?

gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 28M

YH
