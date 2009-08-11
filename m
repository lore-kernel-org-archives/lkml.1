Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZHKOPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZHKOPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZHKOPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:15:06 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:42476 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZHKOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:15:05 -0400
Date: Tue, 11 Aug 2009 11:40:25 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090811094025.GC3251@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8133ED.6070304@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> suggest if you want something more complex that allows the user to just  
> pick a location/size and not worry about windows at all

That's exactly the whole point. I think each bridge should manage
its resources; putting this on the upper layer would mean the
layer should have a mechanism of 'discovering' what the bridge
can/can't do. Anyway this could be revisited later.
I'm preparing a patch for this.

>> - Most accesses are 32-bit accesses. Treating all of them
>>   as 64-bit accesses would decrease performance for most of
>>   them--which happen to be 32-bit.
> I'm not - I'm storing them as 64-bit values, which they are, in the  
> structures used in *software*. These are then split *when* a write to  
> the hardware registers is required. Similarly, when the registers are  
> occasionally read they are combined and stored as a 64-bit value. This  
> simplifies all *software* checking and manipulation. By storing these as  
> 2 32-bit values every driver that uses the VME core will need to convert  
> pci addresses, vme addresses and counts to 2 32-bit values. That is 
> madness.

I agree with you on that's painful for doing 64-bit accesses.
However I'm still not convinced on the performance side (I mean
software), since most of the time the upper 32bits will be empty.
Will have a look though.

Cheers,
E.
