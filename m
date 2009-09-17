Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZIQQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZIQQqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZIQQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:46:21 -0400
Received: from claw.goop.org ([74.207.240.146]:58746 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZIQQqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:46:20 -0400
Message-ID: <4AB267DC.50901@goop.org>
Date: Thu, 17 Sep 2009 09:46:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Keir Fraser <keir.fraser@eu.citrix.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [RFC][PATCH 03/10] xen/hybrid: Xen Hybrid Extension
 initialization
References: <C6D79444.14F51%keir.fraser@eu.citrix.com>
In-Reply-To: <C6D79444.14F51%keir.fraser@eu.citrix.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/09 23:22, Keir Fraser wrote:
>> I think having an option to put PV guests into an HVM container is a
>> good one, but as I mentioned in the other mail, I don't think this is
>> the right approach.
>>
>> It would be much better to make it so that an unmodified guest works in
>> such a mode; even with no specific optimisations the guest would get
>> benefit from faster kernel<->usermode switches.
>>     
> By unmodified you mean ordinary PV guest?

Right.

>  It's an interesting comparison --
> PVing an HVM guest, versus HVMing (to some extent) a PV guest.
>   

KVM is basically using the model of starting with a fully emulated hvm
domain, then adding paravirtualizations as incremental extensions to
that.  If you want to go that route, then we may as well just adopt
their interfaces and use the existing kernel support as-is (though their
most useful paravirtualization - time - is adopted from Xen's ABI).

If we want to get a PV kernel which makes use of hvm features, then we
should do the analogous thing in the other direction: use the current PV
ABI as baseline, then add small optional extensions to take advantage of
the HVM container's features.

    J
