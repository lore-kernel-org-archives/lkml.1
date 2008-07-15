Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYGORst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYGORst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGORsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:48:40 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:34268 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYGORsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:48:39 -0400
Message-ID: <487CE2E7.90505@csr.com>
Date: Tue, 15 Jul 2008 18:48:23 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       linux-usb <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Dropping WUSB/UWB from my patch queue
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com>
In-Reply-To: <20080715155313.GA3075@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2008 17:48:23.0936 (UTC) FILETIME=[FA5A2000:01C8E6A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jul 07, 2008 at 11:03:28AM +0100, David Vrabel wrote:
>> Greg KH wrote:
>>> Hi David,
> 
>>> In looking further at the WUSB/UWB code, it doesn't look like it is
>>> going to make it for the 2.6.27 kernel tree due to the reliance on some
>>> contriversial core USB changes as well as a total lack of documentation
>>> for the sysfs apis.
>> I assume you are referring to the usb_dev_reset_delayed() change here.
>> This is only required by the wire adapter code and should not prevent
>> the majority of the UWB and WUSB stack from being merged.
> 
> Ok, thanks for letting me know, I did not realize this.
> 
>> You should postpone:
>>
>> usb-add-usb_dev_reset_delayed.patch
>> wusb-add-the-wire-adapter-core.patch
>> wusb-add-hwa-hc-wireless-host-controller-driver.patch
>> wusb-wa-abort-rpipe-request-type-fix.patch

I took another look at where usb_dev_reset_delayed() is used and there
are more places.  You will also need to postpone:

uwb/uwb-add-hwa-rc-radio-controller-driver.patch
uwb/uwb-i1480-driver.patch
uwb/uwb-i1480-wlp-driver.patch
uwb/uwb-disable-command-event-filtering-for-DUB-1210.patch
uwb/uwb-add-intel-i1480-hwa-to-the-uwb-rc-quirk-table.patch

And since there are now no drivers for WLP hardware you may also postpone:

uwb/uwb-add-wimedia-llc-protocol-core.patch
uwb/uwb-wlp-messages.patch
uwb/uwb-wlp-wss.patch
uwb/uwb-wlp-build-system.patch
uwb/wusb-drivers-uwb-wlp-sysfs.c-move-misplaced-debug-statement.patch

> Will the code still work properly for users with these patches removed?
> If so, I'll reconsider sending this for 2.6.27.

Yes, users of WHCI WUSB host controllers are unaffected.

>> I will correct the lack of sysfs API documentation this week.  Please
>> advise on where the documentation should go and its style and format.
>> Be aware that some of the API is experimental and subject to change. I
>> will ensure the documentation is clear on this and that the Kconfig
>> entries depend on EXPERIMENTAL.
>>
>> Would this be sufficient to reinstate the majority of the UWB and WUSB
>> stacks for 2.6.27?
> 
> Yes.  I'll take what you sent me, and try to reorder things to make it
> so that we can get the majority of the code into .27, I don't want this
> to live outside the tree for any longer either, that's why I started
> working on getting this mess cleaned up in the first place :)

Okay. Good.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
