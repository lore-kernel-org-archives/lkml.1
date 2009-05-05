Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZEEW62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZEEW62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZEEW6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:58:19 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48231 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZEEW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F++3/a3O1lCILowr/u7xEOAMySHElK42iQWnfBFwVGSPhtykFlyzV0oNm9J8nF+LZx
         yTf18hZCtDCsW8QtmMP2GnX7iMPxyT3Q8a8t3FtnkPDPSQtEhjveNdHf/nLmgTzs9PKX
         SomYzP48zPxA+13RfQTIFfmowS31xXjjev4Zc=
MIME-Version: 1.0
In-Reply-To: <20090505224031.GA4052@suse.de>
References: <20090504220454.3F71148FB8@coco.kroah.org>
	 <200905052036.24106.s.L-H@gmx.de> <20090505221403.GA4714@suse.de>
	 <2f11576a0905051526j73dd1570nb440e4b78e3b35a9@mail.gmail.com>
	 <20090505224031.GA4052@suse.de>
Date: Wed, 6 May 2009 07:58:16 +0900
X-Google-Sender-Auth: 5ffa5c43254faf48
Message-ID: <2f11576a0905051558p21dc0d91o25ef2cd7cf677575@mail.gmail.com>
Subject: Re: patch mm-fix-committed_as-underflow-on-large-nr_cpus-environment.patch 
	added to 2.6.29-stable tree
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Could you please post oops log?
>> current mmotm (include this patch) works fine on my x86_64 box. Then,
>> I have no hint now ;-)
>
> Ok, I'll apply the patch and reboot and take a picture of it...

umm.

Greg, your stable queue has following function?
2.6.29.2 + this patch don't make correct mmap_init() on my box.
(instead, changing unrelated function)

Please check.

--------------------------------------------------------------------------------------
/*
 * initialise the VMA slab
 */
void __init mmap_init(void)
{
        int ret;

        ret = percpu_counter_init(&vm_committed_as, 0);
        VM_BUG_ON(ret);
        vm_area_cachep = kmem_cache_create("vm_area_struct",
                        sizeof(struct vm_area_struct), 0,
                        SLAB_PANIC, NULL);
}
--------------------------------------------------------------------------------------
