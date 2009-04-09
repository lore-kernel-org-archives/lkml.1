Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZDIEoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZDIEoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758885AbZDIEoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:44:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:51920 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbZDIEoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XeDMYFxAQHqEtSgQySuBMyFTQy38enxArNHMjKlKE/0msOIiC6KCpsXPFDdD/jDFBc
         wfhAPIvuobLJC0H+45qdkASKe4VSeh4hmXjmOSI+Ze4s4EX573n5sJmt4iBRt0CnoBwo
         P/2VeeZwsQy70+jodKEXO2Pz91w+tesyhxgLU=
MIME-Version: 1.0
In-Reply-To: <200904081608.55746.mark.langsdorf@amd.com>
References: <200903171457.25582.mark.langsdorf@amd.com>
	 <200904081608.55746.mark.langsdorf@amd.com>
Date: Wed, 8 Apr 2009 21:44:07 -0700
Message-ID: <86802c440904082144m54e2dba5n6c89624481fb5fa1@mail.gmail.com>
Subject: Re: [PATCH] Enable GART-IOMMU only after setting up protection 
	methods
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 2:08 PM, Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> The current code to set up the GART as an IOMMU enables GART
> translations before it removes the aperture from the kernel
> memory map, sets the GART PTEs to UC, sets up the guard and
> scratch pages, or does a wbinvd().  This leaves the possibility
> of cache aliasing open and can cause system crashes.
>
> Re-order the code and add tlbflush so as to enable the
> GART translations only after all safeguards are in place and
> the tlb has been flushed.
>
> AMD has tested this patch and seen no adverse effects.

how about system with AGP card and more than 4g system RAM?

also it seems flush_gart() in init_k8_gatt() and gart_iommu_init()
could be removed?

YH
