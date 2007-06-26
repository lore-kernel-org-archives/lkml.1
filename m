Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXFZPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXFZPzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbXFZPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:54:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:9060 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXFZPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AIfojOimZbsaBGo0aQ575CPcjYoYtQMwdAoVIo2qVp+M6JAwg4UFZsCrmOacD14VZQNJgV1NPazjbfbyKYqBRCTcHKarKKcU3LUFakeQtXJqqCfp2pltj850oq4lw0vc5vODtoC35odMmayUjET4hT+p3BOpJUCtbtofv+vm7jI=
Message-ID: <86802c440706260854w302df509xdba86f29989a5783@mail.gmail.com>
Date: Tue, 26 Jun 2007 08:54:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Justin Piszcz" <jpiszcz@lucidpixels.com>
In-Reply-To: <20070626153911.GC5244@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706251434.43863.jesse.barnes@intel.com>
	 <20070625233433.GA32306@one.firstfloor.org>
	 <200706251636.53636.jesse.barnes@intel.com>
	 <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
	 <20070626153911.GC5244@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Andi Kleen <andi@firstfloor.org> wrote:
> > For the K7 and K8 cores AMD systems are exactly like Intel systems
> > with respect to MTRRs (although AMD systems also have additional registers)
> > For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there
>
> It's called K8RevE, not K9

For K8 Rev F and later, if you are using TOM2, cpu will assume the mem
between 4G and TOM2 is WB.

I think rule could be:
scan the var mtrrs to find out if there is any mtrr is used for 4G
above is set to WB, if it is true, will use trimming tricks.

YH
