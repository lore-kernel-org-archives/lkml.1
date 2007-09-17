Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbXIQTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbXIQTeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXIQTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:34:09 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:37913 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXIQTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:34:07 -0400
Message-ID: <46EED6A5.4080109@codemonkey.ws>
Date: Mon, 17 Sep 2007 14:33:57 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org>	<46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org>	<46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org>	<46EB0657.40603@codemonkey.ws>	<97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>	<46EB1285.5050807@goop.org>	<97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com>	<46EB2716.1070908@goop.org>	<97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com>	<46EB6556.5020506@goop.org>	<97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com>	<46EC233B.5010209@us.ibm.com>	<97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com>	<46EEC6FE.5060306@us.ibm.com> <46EED256.40801@goop.org>
In-Reply-To: <46EED256.40801@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> I'm starting to lean toward just using 0000.  If for no other reason
>> than the hypercall space is unsharable.
>>     
>
> Well, it could be, but it would take affirmative action on the guest's
> part.  If there's feature bits for each supported hypercall interface,
> then you could have a magic MSR to select which interface you want to
> use now.  That would allow a generic-interface-using guest to probe for
> the generic interface at cpuid leaf 0x40001000, use 40001001 to
> determine whether the hypercall interface is available, 4000100x to find
> the base of the magic msrs, and write appropriate msr to set the desired
> hypercall style (and all this can be done without using vmcall, so it
> doesn't matter that hypercall interface is initially established).
>   

The main thing keeping me from doing this ATM is what I perceive as lack 
of interest in a generic interface.  I think it's also a little 
premature given that we don't have any features on the plate yet.  
However, I don't think that means that we cannot turn KVM's PV into a 
generic one.  So here's what I propose.

Let's start building the KVM PV interface on 4000 0000.  That means that 
Xen cannot initially use it but that's okay.  Once KVM-lite is merged 
and we have some solid features (and other guests start implementing 
them), we can also advertise this interface as a "generic interface" by 
also supporting the signature on leave 4000 1000 and using the MSR 
trickery that you propose.

As long as we all agree not to use 4000 1000 for now, it leaves open the 
possibility of having a generic interface in the future.

Regards,

Anthony Liguori

>     J
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>
>   

