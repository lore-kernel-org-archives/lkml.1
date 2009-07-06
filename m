Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZGFHnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZGFHnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZGFHnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:43:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbZGFHna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:43:30 -0400
Message-ID: <4A51AB17.5050404@redhat.com>
Date: Mon, 06 Jul 2009 09:43:19 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com> <20090703160046.GA4262@infradead.org>            <4A4E765F.4000501@redhat.com> <15093.1246720530@turing-police.cc.vt.edu>
In-Reply-To: <15093.1246720530@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/09 17:15, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 03 Jul 2009 23:21:35 +0200, Gerd Hoffmann said:
>
>> Usually it is *much* faster, but when the host is quite loaded it can
>> take a unusual long time.  With 10 seconds it happends in practice now
>> and then that a virtual machine fails to boot just because the virtual
>> root disk didn't show up fast enough.
>
> Are people actually trying to boot a guest on a host machine so loaded that
> disks take that long to show up - and expect things to work in any sane
> matter?

Even on machines which can handle their load just fine under normal 
circumstances you may see that behavior in case of load peaks.  Booting 
a bunch of virtual machines at the same time can trigger it for example.

> I'm tempted to suggest that booting under conditions like that is almost
> deserving of its own kernel Tainted flag.  If devices aren't showing up in
> a timely manner, we probably need to be leery of any other kernel timeout
> values as well...

It is pointless to taint just because of a unusual delay at some random 
point in time.  A virtual machine can see higher delays due to load 
peaks on the host anytime.  The flag wouldn't carry any useful information.

You could add TAINT_VIRT to flag *all* vm guests, but as the boot log 
gives you that information already it is pointless too IMHO.

cheers,
   Gerd

