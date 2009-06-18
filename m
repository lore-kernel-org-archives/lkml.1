Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZFRRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZFRRnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZFRRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:43:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51615 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZFRRnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LPIwStXICMFuGIO7ju3H0ObJkm203pd+ajkX/IW8Ni5xjFr2H8ZWfE/zs8OBZziIgZ
         2B1+cqvs4LcyUTrxg7wVy6Hdk4gZhzJJv7lK7NOlh0diuXOqFrcFFejO7BlHWwoHI1fR
         49rqWiGin3OSv9fYBdWIwv29NQcQj/FawV1rk=
MIME-Version: 1.0
In-Reply-To: <200906181423.11245.herton@mandriva.com.br>
References: <200906161701.45234.herton@mandriva.com.br>
	 <200906172137.43870.herton@mandriva.com.br>
	 <200906180328.07976.fmhess@speakeasy.net>
	 <200906181423.11245.herton@mandriva.com.br>
Date: Thu, 18 Jun 2009 21:43:07 +0400
Message-ID: <1a297b360906181043l7291817du8e8de0048b73d9e1@mail.gmail.com>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based 
	cards
From: Manu Abraham <abraham.manu@gmail.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: fmhess@users.sourceforge.net, Ian Abbott <abbotti@mev.co.uk>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herton,

On Thu, Jun 18, 2009 at 9:23 PM, Herton Ronaldo
Krzesinski<herton@mandriva.com.br> wrote:
> Em Quinta-feira 18 Junho 2009, às 04:28:04, Frank Mori Hess escreveu:
>> On Wednesday 17 June 2009, Herton Ronaldo Krzesinski wrote:
>> > >
>> > > Your patch breaks configuration of the board unless the bus and slot
>> > > are explicitly specified.  Just make a minimal patch that replaces
>> > > pci_get_device with pci_get_subsys and fixes the problem that was
>> > > reported.
>> >
>> > Hmm that's not what the patch does, it doesn't break configuration,
>> > keeps the same logic as before (I was wrong in my last email replying to
>> > myself), check it, if it->options[0] and it->options[1] isn't specified,
>> > the pdev is valid so the for loop exits (see !pdev check).
>>
>> Your right.  However, it also turns a loop over pci devices into a loop
>> over pci ids, which appears to break the case of multiple s626 boards
>> where the bus/slot of the second s626 board is specified.  If you're not
>> willing to provide a minimal patch that just fixes the reported problem,
>> just say so.  It would have been less effort for me to do it myself than
>> analyze what your changes are breaking.
>
> That's part of reviewing process, I just wanted to enhance it in case more pci
> ids are added in the future along with the switch to pci_get_subsys, I don't
> know why you act like that, you don't want the code to be enhanced? Other
> comedi driver loop over ids, for example gsc_hpdi
>
> And indeed what you say it's true, there is a bug in the patch now that you
> checked it out properly, it has a problem with this multiple s626 case, fixed
> that now. Pointing out the problem instead just saying it's broken helps :)
>
> I also removed the obligation to add sub ids and re-factored the patch, that
> was too much and not good, just a simpler loop over pci id array is used now,
> and a comment was added in pci id list telling people that they should add
> subvendor:subdevice ids for boards with vendor:device == 0x1131:0x7146,
> in case new boards with this id appear.


Since there is valid subsystem information: why do you have to loop
over the ID's
manually in the driver ?

Can't the ID's be set into the PCI ID table and a normal pci_probe be
used instead ?
Not that i am familiar with the comedi stuff though ...

We use the probe method directly (rather than pci_get_ ) for most of
the multimedia drivers. As an example this is what i do:
http://jusst.de/hg/saa716x/file/59dd985d4473/linux/drivers/media/dvb/saa716x/saa716x_budget.c

Maybe it helps you in some way.

Regards,
Manu
