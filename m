Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbXHJBs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbXHJBs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXHJBsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:48:21 -0400
Received: from il.qumranet.com ([82.166.9.18]:34009 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbXHJBsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:48:20 -0400
Message-ID: <46BBC3D6.902@qumranet.com>
Date: Fri, 10 Aug 2007 04:48:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Gabriel Barazer <gabriel@oxeva.fr>, Andi Kleen <ak@suse.de>,
       Jim Mattson <jmattson@vmware.com>, linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
References: <46A7E606.4030001@oxeva.fr> <46B4A7E4.4030907@vmware.com> <46BB7FCC.4040509@qumranet.com> <46BBA310.6060706@vmware.com>
In-Reply-To: <46BBA310.6060706@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Avi Kivity wrote:
>>
>> We haven't seen any issue with the 2.6.22 boot decompressor.  Which 
>> of the four (fs, gs, ldt, or tr) were proving problematic and why?
>
> It was tr that was affecting Workstation, since we boot through normal 
> BIOS path, and only a 16-bit task was loaded at this point.
>

Ah.  Maybe we didn't have an exit while we were in long mode with the 
16-bit tss, so VT didn't notice the illegal combination.
