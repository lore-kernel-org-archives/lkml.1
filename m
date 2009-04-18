Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZDRXg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZDRXg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZDRXgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:36:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:1377 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZDRXgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-length:x-uid
         :x-kmail-transport:x-kmail-quoteprefix:x-kmail-recipients
         :x-kmail-encryptionstate:x-kmail-signaturestate
         :x-kmail-signatureactionenabled:x-kmail-encryptactionenabled
         :x-kmail-cryptomessageformat:x-kmail-identity:user-agent;
        b=f89iCuKho1/qMJnzSHqIOTQY6GmFiyFz+dclH1LpAwkPc3vbF57h2PFMUfwBIz1iRP
         5uH2XkslMNfxc1eEZeacfH9fVEdPfU/EOiQrBkuy67ZY7fv0q3POP9lHMr1Q07vXkuAL
         Z5Jz7zCMAVkL1ThPJIpPkQ7BNRXP1y4oeE28o=
Date: Sat, 18 Apr 2009 16:36:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Sassenberg <stefan.sassenberg@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /proc/bus/input/devices changing while booting
Message-ID: <20090418233608.GC32346@dtor-d630.eng.vmware.com>
References: <49CA59E8.7080201@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CA59E8.7080201@gmx.de>
X-Length: 1175
X-KMail-Transport: Mialhub
X-KMail-QuotePrefix: >
X-KMail-Recipients: Stefan Sassenberg <stefan.sassenberg@gmx.de>, LKML
	<linux-kernel@vger.kernel.org>
X-KMail-EncryptionState: N
X-KMail-SignatureState: N
X-KMail-SignatureActionEnabled: false
X-KMail-EncryptActionEnabled: false
X-KMail-CryptoMessageFormat: 15
X-KMail-Identity: 579597780
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Wed, Mar 25, 2009 at 05:20:56PM +0100, Stefan Sassenberg wrote:
> Hello,
>
> while booting, an init-script on my machine greps the Handlers entry of  
> a certain device (USB touchscreen) from /proc/bus/input/devices. It ends  
> with "event2", so I configure my software to listen for events in  
> /dev/input/event2. A few seconds later /proc/bus/input/devices changes,  
> the order of the devices is different and the Handlers entry for my  
> device ends with event1 making my device misconfigured and thus unusable.
>
> Can anybody explain that behaviour? How can I get the final eventX  
> device file?
>
> I'm using kernel 2.6.28.8 on an Intel Celeron, chipset ICH5.
>

Something causes disconnect of your touchscreen. I think this can happen of 
EHCI is loaded after UHCI/OHCI and they all figure our which devices should be 
driven by whom. Does it help if you compile EHCI in kernel or make sure it 
gets loaded first?

-- 
Dmitry
