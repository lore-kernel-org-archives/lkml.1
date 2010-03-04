Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0CDC7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:59:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37930 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CDC7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rPQycVNDIemLKSIFQdpr9ji/wcY7XMrAxf+dX6TN5AFHUUTzkJEp6wOWrcIi8lK8dn
         ASTDrSte4UP/mYpb6ULNwFM9dnYwwCenHBfAakHNuCZHaeRQXLHp2vS0z7x9dlfYZLqP
         ufKTMVqahjVr+MJTYTU39bNQp4/Z2kmQRCStM=
MIME-Version: 1.0
In-Reply-To: <4B8B901E.4050302@ladisch.de>
References: <be233a491002282130m3c637cfbw6648a77548241a64@mail.gmail.com>
	 <4B8B901E.4050302@ladisch.de>
Date: Wed, 3 Mar 2010 18:59:31 -0800
Message-ID: <be233a491003031859s7d409e11k599a319ce04b7696@mail.gmail.com>
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 1:59 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> @@ -438,6 +469,17 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>>  {
>>        struct hpet_dev *devp;
>>
>> +       switch (cmd) {
>> +       case HPET_INFO:
>> +               break;
>> +       default:
>> +               {
>> +                       int r = hpet_alloc_timer(file);
>
> Applications might want to use HPET_INFO to find out which timer they
> got, so I think the driver cannot avoid allocating a timer in this case.

Oh, I missed commenting this in my first reply. I chose to make
HPET_INFO specify timer -1 in case a timer isn't currently allocated.
You think there are extant cases of programs depending on open then
immediate HPET_INFO having a timer allocated? Seems obscure to me. If
so I can change that. I did add the explicit form of allocating timers
to accomodate such a case hypothetically (open, allocate timer, get
info).
