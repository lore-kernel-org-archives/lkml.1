Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXCUNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXCUNEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXCUNEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:04:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:61579 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbXCUNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tX2TkTOeUjddbIK4T+MrTei1xG8IvQzJOnyhPBa8y2VjNDDHyNiC2Z2m2ofLntZPGcjIAaWhN8bDd+C+KB5WOosIT4k5urCHVTd1JfUVauCHq8+SbYjCEp7OlxhdE88v4ZXEXzK1ZzlZWWB5zEV/pq3aTfVBptmlbSmLG6x6uic=
Message-ID: <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
Date: Wed, 21 Mar 2007 14:04:19 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: tglx@linutronix.de, "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       "Len Brown" <lenb@kernel.org>, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <200703211342.59093.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211137.10884.ak@suse.de>
	 <1174475666.10840.44.camel@localhost.localdomain>
	 <200703211342.59093.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/21, Andi Kleen <ak@suse.de>:
> On Wednesday 21 March 2007 12:14, Thomas Gleixner wrote:
> > On Wed, 2007-03-21 at 11:37 +0100, Andi Kleen wrote:
> > > > The BIOS/ACPI is broken and does only expose C1, which should not
> > > > switch off LAPIC. The BIOS is switching into deeper C-States behind the
> > > > kernels back somehow.
> > >
> > > Hmm, perhaps we can check AMD && (cstate >= 2 || has a battery) ?
> > > Should be doable by looking up the battery object in ACPI
> >
> > Which makes us rely on another ACPI feature. What guarantees that the
> > ACPI tables are correct for this one ?
>
> Nothing, but wrong C2 and wrong battery state together seems unlikely.
>
> -Andi
>

Hello

I uploaded the output of dmesg (kernel 2.6.21-rc4-git5) (battery / ac)
and dmidecode
I can boot on battery with nolapic_timer and the second core is online, too.
/proc/acpi/processor/C000/ shows the same as before but
/proc/interrupts has changed:

(battery)
           CPU0       CPU1
  0:      47131          0  local-APIC-edge-fasteoi   timer
LOC:          0      46978

(ac)
           CPU0       CPU1
  0:      59137          0  local-APIC-edge-fasteoi   timer
LOC:          0      58984


- Stefan Prechtel
