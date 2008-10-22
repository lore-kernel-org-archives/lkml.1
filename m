Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYJVOx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYJVOx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYJVOxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:53:47 -0400
Received: from outbound-mail-143.bluehost.com ([67.222.38.33]:57444 "HELO
	outbound-mail-143.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753084AbYJVOxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:53:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qkuc5GWtYxN0tPvDVHnZ6swsOOeKq2ZK0b7IrbkIMKS6JFiA4VKjjlFv9zGLDxQ/X3JymbKdehAkF48yIAv0tB8vWJIpJYX5Xe4YrQu8P3UhZmHQc1jSSXzGvuYKIKaU;
Message-ID: <48FF3E3B.3050006@uniscape.net>
Date: Wed, 22 Oct 2008 22:52:43 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yu Zhao <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 9/16 v6] PCI: add boot option to align MMIO resources
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084324.GI3773@yzhao12-linux.sh.intel.com> <200810220834.07222.bjorn.helgaas@hp.com>
In-Reply-To: <200810220834.07222.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.38.26.55 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 22 October 2008 02:43:24 am Yu Zhao wrote:
>> This patch adds boot option to align MMIO resource for a device.
>> The alignment is a bigger value between the PAGE_SIZE and the
>> resource size.
> 
> It looks like this forces alignment on PAGE_SIZE, not "a bigger
> value between the PAGE_SIZE and the resource size."  Can you
> clarify the changelog to specify exactly what alignment this
> option forces?

I guess following would explain your question.

>>  int pci_resource_alignment(struct pci_dev *dev, int resno)
>>  {
>> -	resource_size_t align;
>> +	resource_size_t align, bios_align;
>>  	struct resource *res = dev->resource + resno;
>>  
>> +	bios_align = pcibios_resource_alignment(dev, resno);
>> +
>>  	align = resource_alignment(res);
>>  	if (align)
>> -		return align;
>> +		return align > bios_align ? align : bios_align;
>>  
>>  	dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
>>  	return 0;

