Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYJJE4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYJJE4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYJJE4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:56:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:49266 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJJE4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eMTnQSVdO2dmURhuArAM5mDVEpk9w+K5W1C0YdDOASDfwzcrSAGLVweAZA8iWumFQH
         IzM78AayThEhZk2fsLgtDA2HzUBC7tkrTgXj+R5ue8e2MPdDzCfbKbxLq3zdrSbTDAI6
         05supr4diQ3jdDF/nFp2kwcgTF3iPTOHmp1ZE=
Message-ID: <86802c440810092156i18bb7699vb8e90d52accad781@mail.gmail.com>
Date: Thu, 9 Oct 2008 21:56:33 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] pci: print out DMA mask info
Cc: grundler@parisc-linux.org, matthew@wil.cx, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20081010114003X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
	 <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org>
	 <20081010114003X.fujita.tomonori@lab.ntt.co.jp>
X-Google-Sender-Auth: 1e1ff014db6077d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 7:40 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 09 Oct 2008 16:05:57 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Grant Grundler wrote:
>> > On Thu, Oct 09, 2008 at 02:51:32PM -0700, Yinghai Lu wrote:
>> >> On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>> >>> Why's that interesting to the sysadmin of the machine?  To the driver
>> >>> writer, certainly.  But what's the use of it to the people using the
>> >>> machine?
>> > ...
>> >> make linux kernel act like black box as other os?
>> >
>> > I don't understand your reply.
>> > If someone thinks linux is a black box, printing this message won't help them.
>> >
>> could find out easily why some driver doesn't set dma mask correctly.
>> like why
>>       qlogic qla2xxx only set consistent to 64bit,
>>       emulex lpfc not set consistent to 64bit
>
> IIRC, except for one SGI architecture, coherent_dma_mask is
> meaningless, dma_mask is always equal to coherent_dma_mask. Lots of
> IOMMU implementations ignore coherent_dma_mask and use dma_mask for
> alloc_coherent(). Some drivers doesn't set up coherent_dma_mask.

ehci_hcd 0000:00:02.1: using 31bit consistent DMA mask
==> ck804 ehci, is using 31bit for consistent dma mask, at still use
32 bit for dma mask.

qlogic qla2xxx  and emulex lpfc dma mask and consistent_dma_mask is different...
could have some story for them

at least gart iommu is honoring the consistent dma mask.
by calling dma_alloc_coherent_mask(dev, flag)

if device could use 64 bit coherent dma mask, that is driver problem...
print it out could put them in focus.

YH
