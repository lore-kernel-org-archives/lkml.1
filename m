Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZK2MyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZK2MyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 07:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZK2MyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 07:54:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50745 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZK2MyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 07:54:04 -0500
Message-ID: <4B126EEB.1040908@garzik.org>
Date: Sun, 29 Nov 2009 07:54:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
References: <4B110F79.8080405@redhat.com> <4B111ADC.9020800@garzik.org> <4B123A34.5090509@redhat.com>
In-Reply-To: <4B123A34.5090509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 04:09 AM, Stefan Assmann wrote:
> On 28.11.2009 13:43, Jeff Garzik wrote:
>> On 11/28/2009 06:54 AM, Stefan Assmann wrote:
>>> From: Stefan Assmann<sassmann@redhat.com>
>>>
>>> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
>>> terms listed in the "Trademark and Logo Usage Guidelines".
>>> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
>>>
>>> Additionally some renames of Gb/s to GT/s where appropriate, concerns
>>> PCIe.
>>>
>>> This is a followup to the discussion at:
>>> http://lkml.org/lkml/2009/10/14/107
>>> Patch is based on 2.6.32-rc8.
>>>
>>> Signed-off-by: Stefan Assmann<sassmann@redhat.com>
>>
>> NAK, this clearly introduces bugs and changes sysfs output (ABI).
>>
>> Typically this type of change is pointless churn that creates far more
>> problems than it "solves."
>
> Hi Jeff,
>
> I see you point in not liking this kind of change. What kind of cleanup
> would be ok in your opinion?

Think about this from an engineering perspective.  This patch is driven 
not by any real technical need, but more by marketing and trademark folks.

The absolute best case scenario for this patch is that nothing changes, 
from an implementation and behavior standpoint.  The worst case, of 
course, is that it introduces bugs (which it does).

You also incur the standard costs of any kernel change:  you've just 
made the diff between, for example, a vendor kernel's foo_driver.c and 
upstream's foo_driver.c a lot larger, and more difficult to discern 
real, technical changes to the code.

Of course, we change the kernel every day -- but we also know that 
change itself has cost, and a lot of code changes for cosmetic reasons 
have the potential for greater negative costs, and fewer positive benefits.

Next, IMO, you don't have any idea how maintainers will react to this 
patch, because you CC'd so few of them.  People who perform tree-wide 
changes should take the time to CC __every__ relevant maintainer.  If 
you are changing somebody's code, you should always let them know about 
it, and give them an opportunity to review the change. 
scripts/get_maintainer.pl can help with this.

So, while the PCI maintainer might agree with the nomenclature change, 
he is not the most qualified person to state that your changes have no 
effect on drivers/edac/ppc4xx_edac.c, for example.

Finally, split your patch up.  I would suggest starting with 100% 
comment changes that are guaranteed with mathematical certainty to not 
change the compiler-generated code at all.  That will make the remaining 
changes much easier to review, if they are in separate patches from the 
comment-only changes.

	Jeff





