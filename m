Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYIBOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYIBOgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYIBOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:36:07 -0400
Received: from smtp03.osg.ufl.edu ([128.227.74.70]:43236 "EHLO smtp.ufl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751351AbYIBOgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:36:06 -0400
Message-ID: <1147742858.207301220366162943.JavaMail.osg@osgjas01.cns.ufl.edu>
Date: Tue, 2 Sep 2008 10:36:02 -0400 (EDT)
From: "CHADHA,VINEET" <vineet@ufl.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>, "CHADHA,VINEET" <vineet@ufl.edu>
Subject: Re: TLB evaluation for Linux
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: GatorMail WebMail (http://GatorMail.sf.net/)
X-Originating-IP: 10.5.153.246 [10.5.153.246]
X-UFL-Spam-Status: hits=-2.5, required=5, tests=ALL_TRUSTED,TW_VL
X-UFL-Scanned-By: CNS Open Systems Group (http://open-systems.ufl.edu/services/smtp-relay/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Nick.

A PhD dissertation to study scalability of micro-kernels can be 
found :

http://l4ka.org/publications/2005/uhlig_phd-thesis_scalability.pdf

An example of study I would like to do through Full system 
simulator is in Figure 4.11.

Regarding TLB flushing modifications, I will get back to you (and 
mailing list) after I get a better understanding of source code.

Regards,
Vineet


On Tue Sep 02 00:39:00 EDT 2008, Nick Piggin 
<nickpiggin@yahoo.com.au> wrote:

> On Tuesday 02 September 2008 14:12, CHADHA,VINEET wrote:
>> Hi,
>> 
>> I have been working to evaluate TLB performance for Linux O/S and
>> virtualized workloads(such as Xen) in a Full system 
>> simulator(e.g.
>> simics). While my evaluation is in nascent stage, I do notice 
>> that
>> most of the IPIs in multi-core environments cause complete TLB
>> Flush.
>> 
>> I want to evaluate cost of TLB shootdown including re-population
>> vs. each entry shootdown (invlpg). While a similar study has been
>> done in other kernels (e.g. L4 kernel), I am not aware if it has
>> been done for Linux O/S.
> 
> This is a very interesting area to investigate. Do you have a 
> link to
> any of the existing studies?
> 
> 
>> Are there hooks or patches to test or evaluate TLB performance.
>> Specifically, I would like to know where to make changes in Linux
>> kernel to support each entry shootdown.
> 
> The main thing I guess is to look at tlb_flush(), called by 
> tlb_flush_mmu
> when unmapping user virtual memory, which on x86 is going to call
> flush_tlb_mm, which flushes the entire tlb.
> 
> It would need a bit of reworking of things in order to store the 
> virtual
> address corresponding to each page in the struct mmu_gather, and 
> then
> deciding to branch off to do multiple invlpg if you have only a 
> small
> number of pages to be flushed. I'd suggest the easiest way to get
> something working on x86 would be to modify the asm-generic 
> infrastructure
> (ignore other architectures for the time being).
> 
> You will also have to rework the IPI flushing scheme so that it 
> can handle
> more than one flush_va for invlpg invalidations.
> 
> After you get all this done, you could also look at applying 
> similar
> heuristics to flush_tlb_range. This one should be much easier at 
> this point,
> but it is used in fewer places (eg. mprotect).
> 
> 




