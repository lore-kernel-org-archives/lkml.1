Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZJBHX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZJBHX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZJBHX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:23:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16512 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbZJBHX0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Fri, 2 Oct 2009 03:23:26 -0400
Message-Id: <4AC5C68F0200007800017A3F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 02 Oct 2009 08:23:27 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
Cc: "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       "Martin Wilck" <Martin.Wilck@fujitsu-siemens.com>,
       "pjones@redhat.com" <pjones@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
References: <4AC47DED0200007800017743@vpn.id2.novell.com>
 <4AC5234C.5030409@citrix.com>
In-Reply-To: <4AC5234C.5030409@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com> 01.10.09 23:46 >>>
>On 10/01/09 01:01, Jan Beulich wrote:
>> In virtual environments (namely, Xen Dom0) virt <-> phys and
>> virt <-> isa-bus translations cannot be freely interchanged. When
>> looking at memory below 1M, the latter translations should always
>> be used.
>>   
>
>Do you have a different definition for isa_virt_to_bus in your kernel? 
>As far as I can see it is defined to be the same as virt_to_phys.  Also,
>the ISA memory is identity mapped into the domain's physical mapping
>space, so it should be directly accessible without any problems.

I wasn't sure if this is an issue in the pv-ops kernel, so I copied you just
in case. Yes, we do have a different virt<->isa_bus translation, but
the point of the patch really is that virt<->phys translations are
incorrectly being used here regardless of the underlying environment.

Jan

