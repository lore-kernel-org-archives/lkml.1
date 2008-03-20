Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYCTHpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYCTHpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYCTHoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:44:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:16415 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbYCTHoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n9unqCSVEH8JVqavtV2V8FAcGp44WuXM8q5Vp/SgaXN8UfjxixSrof31yYJKGBOXR1ILBBadyeV8JKqsnMy5EP3OE9qDyjTiINY4oI8Eoa/SaMpeO/mB3CQkL1xdMMS6f5ZQs8zP1E9LTRje4GEZKFwtkFrFX9dyqIBvv8kMT9Y=
Message-ID: <86802c440803200044g54617517k4530db76ebe2cabb@mail.gmail.com>
Date: Thu, 20 Mar 2008 00:44:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran G Thirumalai" <kiran@scalex86.org>
Subject: Re: [patch 1/4] x86: vSMP: Fix is_vsmp_box()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Andi Kleen" <ak@suse.de>, shai@scalex86.org
In-Reply-To: <20080320073902.GB9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080320073740.GA9414@localdomain>
	 <20080320073902.GB9414@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 12:39 AM, Ravikiran G Thirumalai
<kiran@scalex86.org> wrote:
> is_vsmp_box() currently does not work on vSMPowered systems,  as pci cfg
>  space is not read correctly -- This patch fixes it.
>
>  Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>
>  Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
>  ===================================================================
>  --- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c      2008-03-19 13:30:35.116766719 -0700
>  +++ linux.git.trees/arch/x86/kernel/vsmp_64.c   2008-03-19 13:39:20.074685590 -0700
>  @@ -84,8 +84,10 @@ int is_vsmp_box(void)
>                 return vsmp;
>
>         /* Check if we are running on a ScaleMP vSMP box */
>  -       if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  -            (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
>  +       if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  +            PCI_VENDOR_ID_SCALEMP) &&
>  +           (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>  +           PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>                 vsmp = 1;
>
>         return vsmp;

why read two times

or
              (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
should be
            (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))

YH
