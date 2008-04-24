Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYDXBWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYDXBWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYDXBWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:22:24 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:48967 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753615AbYDXBWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o8f/YDOaYvzO40OgCjSSZgy/Ntu4SfqUJ1EIZKSEV19XHto3Xfgq6OkG/Whbqe/2PBh4RLQXjW6tBqZedddvc39ArasoQNWZ40XSoxu+6fz18TVGS7HZ1r5IbZ/y9FdUORa95KfHenbQPd30z6R1HRMaQ7dndifco9gg2auBMLI=
Message-ID: <86802c440804231822s7cc4e2c1vfdb7f40ae0580045@mail.gmail.com>
Date: Wed, 23 Apr 2008 18:22:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <1208996273.9245.18.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
	 <m1hcdsoh1i.fsf@frodo.ebiederm.org>
	 <1208996273.9245.18.camel@concordia.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 5:17 PM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Wed, 2008-04-23 at 06:08 -0700, Eric W. Biederman wrote:
>  > Michael Ellerman <michael@ellerman.id.au> writes:
>  >
>  > > On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
>  > >> this change
>  > >>
>  > >> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>  > >> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>  > >> | Date:   Fri Mar 7 15:53:21 2008 +0530
>  > >> |
>  > >> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>  > >> |
>  > >> | This patch modifies the driver to enable MSI by default for all SAS chips.
>  > >> |
>  > >> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
>  > >> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>  > >> |
>  > >> cause kexec RHEL 5.1 kernel fail.
>  > >>
>  > >> root casue: the rhel 5.1 kernel still use INTx emulation.
>  > >> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec
>  > > path
>  > >>
>  > >> so try to call pci_disable_msi in shutdown patch
>  > >
>  > > How is kdump going to work? Your shutdown routine won't be called and
>  > > you'll have the same problem in the 2nd kernel, won't you?
>  >
>  > Taking a quick look our current msi initialization appears robust in
>  > not assuming the state of the msi config bits.
>
>  But does that help us? What if the device driver in the 2nd kernel
>  assumes it's using INTX, when in fact MSI is enabled on the device. In
>  that case none of the MSI code will even be called AFAIK.

ok. for kdump case, if driver can not use msi (?), with pci=nomsi
we need to call pci_intx_for_msi(dev, 1) at beginning of second kernel.

will produce another patch about that case.

YH
