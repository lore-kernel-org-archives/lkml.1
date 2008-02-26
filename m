Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbYBZTBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbYBZTBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbYBZTBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:01:02 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:43269 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825AbYBZTBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YN9bbplsBFZP5xKUdiit3eSsKna9maVeiyc5FEJGahrk1d3XVbbEzUYMl9GYQSv0kcwzH+3tW72yHICj5+5/rW0HkDUP5vsUaK3XevdJbw8IhhwpRLvPFiEgat1/ObyW0cMVpCkwE5vTGzbw7/l2DrTnd+5CzRwYH6p916k+0DY=
Message-ID: <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
Date: Tue, 26 Feb 2008 11:00:58 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080226184235.GA5914@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802221102.31019.yinghai.lu@sun.com>
	 <200802232148.43255.yinghai.lu@sun.com>
	 <20080224122903.GC13637@one.firstfloor.org>
	 <20080225190819.GE3143@localdomain>
	 <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
	 <20080226033945.GJ3143@localdomain>
	 <20080226034625.GE21577@one.firstfloor.org>
	 <20080226040541.GK3143@localdomain>
	 <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
	 <20080226184235.GA5914@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:42 AM, Ravikiran Thirumalai
<kiran@scalemp.com> wrote:
> On Mon, Feb 25, 2008 at 09:27:42PM -0800, Yinghai Lu wrote:
>  >On Mon, Feb 25, 2008 at 8:05 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
>  >> On Tue, Feb 26, 2008 at 04:46:25AM +0100, Andi Kleen wrote:
>  >>
>  >>  >
>
> >>  >If you can't support that in your hardware you're supposed
>  >>  >to clear it.
>  >>
>  >>  Hmm! How would a hardware vendor do that? That doesn't seem to be clear in
>  >>  the BKDG. (Well, this is the problem with undocumented features :()
>  >>
>  >any good sign for APIC_clustered box? there is apicid between cpus
>  >even all cpu are quadcore and fully populated?
>
>  I would suggest checking the SLIT distances -- On AMD boxes, if you have three
>  different distances between nodes, then that system would be multiboard,
>  and there is no way TSCs can be synced.  On Intel boxes, if there are two
>  different distances between nodes, then this would be a multi board/multi
>  chassi box and TSCs won't be synced.  This is a more generic solution and
>  should work on Summit/Unisys boxes as well.  (I am ignoring Intel CSI for
>  now.  It might need the same treatment as AMD)

1. if acpi=off ?
2. some system will be treated wrong.
my four sockets system
ACPI: SLIT: nodes = 4
 10 13 13 16
 13 10 16 13
 13 16 10 13
 16 13 13 10
my eight sockets system
ACPI: SLIT: nodes = 8
 10 12 12 14 14 14 14 16
 12 10 14 12 14 14 12 14
 12 14 10 14 12 12 14 14
 14 12 14 10 12 12 14 14
 14 14 12 12 10 14 12 14
 14 14 12 12 14 10 14 12
 14 12 14 14 12 14 10 12
 16 14 14 14 14 12 12 10

YH
