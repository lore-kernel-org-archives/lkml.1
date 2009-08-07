Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZHGRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZHGRRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZHGRRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:17:53 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:43846 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZHGRRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RaqOcloiGBEAE7ZqimMg8o9XFRFtrHx7J69O9cP1uE0VoRyUs5p7vmG7nUQ7ZzgA5V
         NXpCcQDL3vTZW1SC/63RUVe3ct7zb3nYKxm4AveRY795ipIhX29VRwMGuM81yxO/UWbM
         MEF+0QUZiyauGaacnSus21a3XfjbCGqCnvk54=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0908071142260.3063-100000@iolanthe.rowland.org>
References: <9b2b86520908070832p2d1658b0t8b1d89d1a034bb9a@mail.gmail.com>
	 <Pine.LNX.4.44L0.0908071142260.3063-100000@iolanthe.rowland.org>
Date: Fri, 7 Aug 2009 18:17:51 +0100
Message-ID: <9b2b86520908071017h606e595fr4488d6ff61cb337c@mail.gmail.com>
Subject: Re: [PATCH 2/7 v3] initdev:kernel:USB init device discovery 
	notification
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David VomLehn <dvomlehn@cisco.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/09, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 7 Aug 2009, Alan Jenkins wrote:
>
>> > +/* The mask of possible USB boot devices depends on what drivers and
>> > + * options have been configured into the kernel.  There are too many
>> > + * USB network config options to list here, so just assume it is always
>> > + * possible to have a USB network device.
>> > + */
>>
>> That could be fixed though.  Make the "USB Network Adaptors" menu into
>> an option.  Then you just have e.g. "CONFIG_NETDEV_USB", plus the two
>> class devices outside the menu (CONFIG_USB_ACM and CONFIG_USB_WDM).

Oops, scratch WDM.  It doesn't actually provide a network device
(otherwise it would depend on NET).

> That could be done.  It might even meet with the approval of the
> networking maintainer, independent of this patch series.
>
> But what if somebody adds yet another networking class driver outside
> the menu?

Hmm.

Ok, how about a single (hidden) USB_HAS_NETDEV.  NETDEV_USB and
USB_ACM select USB_HAS_NETDEV.

Textual juxtaposition or simple copy+paste inside class/Kconfig should
help it get picked up.  And I'd add a comment pointing the bewildered
to the definition of usb_initdev_mask.

I'll write a patch for your inspection this evening.

Alan
