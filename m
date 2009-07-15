Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZGOXNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZGOXNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZGOXNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:13:24 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:25283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbZGOXNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fdiC+WyhRawljj6frSOP5itHwI33nCKOEincciXC89Nb3dA/HfW9eI/xotj7DmhQwP
         26QB6CFT1P5pJNpv59SHWoKHB1TmUlErQDi7wyX/8MoP3RK92DIQ12O13dQPDT41tEaz
         Pna1M0Ho5dXcra1l1b8eG5k2Ue2YDmBwIh7FM=
MIME-Version: 1.0
In-Reply-To: <20090716001016.489fa970@lxorguk.ukuu.org.uk>
References: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>
	 <20090716001016.489fa970@lxorguk.ukuu.org.uk>
Date: Wed, 15 Jul 2009 19:13:23 -0400
Message-ID: <9e4733910907151613n777261e5k3e3c1cd646c7922a@mail.gmail.com>
Subject: Re: Why do we probe option roms at 2K boundaries?
From: Jon Smirl <jonsmirl@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Alan Cox <alan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 7:10 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> interrogating a data structure stored in option-rom memory.  My initial
>> implementation involved blindly scanning from c0000 to f0000 in 512 byte
>> increments.  Neil and others pointed out that this may not be a safe
>
> It isn't safe. If you hit certain ISA devices your system will drop dead.
> OTOH I doubt anyone has an intel matrix raid controller and a WD80x3 on
> the same box ;)

Random link from google, slide 21
http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWAR05005_WinHEC05.ppt

PCI 3.0+ allows 512b alignment, but you must first make sure you are
on a PCI 3.0+ system.

>
>> Recently Hans has been working to get Fedora up and running on a recent
>> Intel software RAID platform and noticed that the option-rom is no
>> longer visible with the 2K aligned scan.  I.e. he needed to make the
>> following changes to the mdadm probe_roms() routine:
>
> Option ROMs should be 2K aligned. Is your data structure part of a ROM or
> an actual ROM header ?
>
>> Is this safe?  Should the kernel be updated as well?  I am assuming that
>> you were the one that originally introduced the 2K aligned scan with
>> this commit from the historical git:
>
> Actually I don't think that was me, don't remember it anyway.
>
> The man to bug at the moment on ROM magic is probably H Peter Anvin
> however.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
