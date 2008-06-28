Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYF1HBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYF1HBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 03:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYF1HBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 03:01:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:22860 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYF1HBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 03:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZhMJoggHOoYUm24XOQQuFOeULxDOtsxBdIjXVsBVViywroV6miSAGMvsi71fEAhGJD
         ftnjVJVBHWFrTyFuzWRgbKmtCN67YeNt8jkZcg454TDgpdovzha5VRYRQLz7AQHsux73
         FAXAM4HOzskKjY2caPF30Z2M6yfv/6PW2GePc=
Message-ID: <86802c440806280001j6184240v49c1a329896d8d45@mail.gmail.com>
Date: Sat, 28 Jun 2008 00:01:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080628063500.GA15710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806252151.29028.yhlu.kernel@gmail.com>
	 <200806271538.46829.yhlu.kernel@gmail.com>
	 <200806272247.11971.yhlu.kernel@gmail.com>
	 <20080628063500.GA15710@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> some end boundary is only page alignment, instead of 2M alignment, so
>> call ker_phycial_mapping_init three times. then don't overmap above
>> the max_low_pfn
>
> applied to tip/x86/unify-setup, thanks Yinghai.
>
>> v2: make init_memory_mapping more solid: start could be any value
>> other than 0
>
> very good idea!

could change
map_pfn_mapped = init_memory_mapping(0, map_low_pfn<<PAGE_SHIFT);
to
map_pfn_mapped = init_memory_mapping(map_pfn_mapped<<PAGE_SHIFT,
map_low_pfn<<PAGE_SHIFT);

only concern is
init_memory_mapping set   _EXEC in page table for kernel code.

YH
