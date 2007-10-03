Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbXJCGWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbXJCGWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXJCGV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:21:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXJCGV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:21:56 -0400
Message-ID: <4703342E.3020101@zytor.com>
Date: Tue, 02 Oct 2007 23:18:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Chuck Ebbert <cebbert@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] mark read_crX() asm code as volatile
References: <470250E0.5090706@openvz.org> <20071002082856.3c478e66@laptopd505.fenrus.org> <47028D99.8020100@redhat.com> <200710022214.55381.nickpiggin@yahoo.com.au>
In-Reply-To: <200710022214.55381.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>>
>> This should work because the result gets used before reading again:
>>
>> read_cr3(a);
>> write_cr3(a | 1);
>> read_cr3(a);
>>
>> But this might be reordered so that b gets read before the write:
>>
>> read_cr3(a);
>> write_cr3(a | 1);
>> read_cr3(b);
>>
>> ?
> 
> I don't see how, as write_cr3 clobbers memory.

Because read_cr3() doesn't depend on memory, and b could be stored in a 
register.

	-hpa
