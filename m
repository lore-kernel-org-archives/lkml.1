Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJIIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJIIiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXJIIiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:38:04 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43647 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752346AbXJIIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:38:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H5/2cN2s8M6qDkjLCnkeRC2nUw8T7M9SSMUkTOXzn/VdoLlcVglTPPT8PqAVPiPCbBZeth59Ki1hU9h+tBJ4hbntSI5D+KwQAGv5VCDSLrsfGijx91UnW444VZEALa3S6f6RwqdsLuEjCFe05YEZB+hK5T77Ba5SbGBIW68Rne4=  ;
X-YMail-OSG: dV49EL8VM1lZBeRnVHmWSOyjITTymPynFlkMCXK9p04xZycGRzn1nU7NsWlInRCOtSJ5leeW6A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Date: Tue, 9 Oct 2007 02:06:21 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1191912010.9719.18.camel@caritas-dev.intel.com> <200710090125.27263.nickpiggin@yahoo.com.au> <1191918139.9719.47.camel@caritas-dev.intel.com>
In-Reply-To: <1191918139.9719.47.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090206.22383.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 18:22, Huang, Ying wrote:
> On Tue, 2007-10-09 at 01:25 +1000, Nick Piggin wrote:
> > On Tuesday 09 October 2007 16:40, Huang, Ying wrote:
> > > +unsigned long copy_from_phys(void *to, unsigned long from_phys,
> > > +			     unsigned long n)

> > I suppose that's not unreasonable to put in mm/memory.c, although
> > it's not really considered a problem to do this kind of stuff in
> > a low level arch file...
> >
> > You have no kernel virtual mapping for the source data?
>
> On 32-bit platform such as i386. Some memory zones have no kernel
> virtual mapping (highmem region etc).

I'm just wondering whether you really need to access highmem in
boot code...


> So I think this may be useful as a 
> universal way to access physical memory. But it can be more efficient to
> implement it in arch file for some arch. Should this implementation be
> used as a fall back implementation with attribute "weak"?

Definitely on most architectures it would just amount to
memcpy(dst, __va(phys), n);, right? However I don't know if
it's worth the trouble of overriding it unless there is some
non-__init user of it.
