Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYJWGvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYJWGvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYJWGvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:51:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:54084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJWGvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ex64NZ7wQfDq5HDWUi+MaT0+Xx1ho1mvp+7Sk3YPKuEP9mfHIEA00RUa2l6g63J1Dv
         ne7RcabmZRfeLYEKeUkg4L5raRUG9lwgjRLJDCpLEEyOSShnobwd26zwfx2yuwvPHxgp
         dDn4jZRM9p1YVJEjP3YM0wteAKH6/NCmUTKb0=
Message-ID: <86802c440810222351g18a34904ka1f3621df7f2614f@mail.gmail.com>
Date: Wed, 22 Oct 2008 23:51:36 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20081023064815.GE31186@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	 <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org>
	 <20081009213551.GC25780@parisc-linux.org>
	 <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
	 <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org>
	 <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org>
	 <20081023064815.GE31186@colo.lackof.org>
X-Google-Sender-Auth: e9b7decffa0294ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:48 PM, Grant Grundler
<grundler@parisc-linux.org> wrote:
> On Wed, Oct 22, 2008 at 06:45:10PM -0700, Yinghai Lu wrote:
>> Grant prefer to add it /sys instead of showing in bootlog
>>
>> so could catch if the driver set the correct dma_mask.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/pci-sysfs.c |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> Index: linux-2.6/drivers/pci/pci-sysfs.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/pci-sysfs.c
>> +++ linux-2.6/drivers/pci/pci-sysfs.c
>> @@ -169,6 +169,21 @@ numa_node_show(struct device *dev, struc
>>  #endif
>>
>>  static ssize_t
>> +dma_mask_bits_show(struct device *dev, struct device_attribute *attr, char *buf)
>> +{
>> +     struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +     return sprintf (buf, "%d\n", fls64(pdev->dma_mask));
>
> Is there any reason to use %d instead of "0x%x" ?
> I'd much rather see this dumped in hex.

that is bits, so it will be 64, 41 instead of 0xfffff

YH
