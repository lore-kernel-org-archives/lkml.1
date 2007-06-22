Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXFVTiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXFVTiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXFVTiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:38:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:3904 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXFVTiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mPxofK4zGpQ1WezVtHSZsOeYzVanujKoUFdxBb6u+3Ew1E6PNEf/QWVY+Qxn8IpFxiLRB0z1TtpRNktIEzGpoxiIM9UGfujaaly8MrxXH7Hk237HBRoIzgKbSKH6SOW8tEms1+Vpjnimgz/NEjo49wW0ppSSnlkxX4R0TaGvkAw=
Message-ID: <86802c440706221238h2ae9ea2nf26ab9c26486e388@mail.gmail.com>
Date: Fri, 22 Jun 2007 12:38:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070622193124.GG5051@rhun.smartcity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
	 <20070622193124.GG5051@rhun.smartcity.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Fri, Jun 22, 2007 at 12:19:15PM -0700, Yinghai Lu wrote:
> > [PATCH] x86-64: disable the GART before allocate aperture
> >
> > For K8 system: 4G RAM with memory hole remapping enabled, or more
> > than 4G RAM installed. when mem is allocated for GART, it will do
> > the memset for clear.  and for kexec case, the first kernel already
> > enable that, the memset in second kernel will cause the system
> > restart. So disable that at first before we try to allocate mem for
> > it.
>
> Why does the memset in the second kernel cause a system restart?

the mem for aperture is still used by GART. or the translation is still enabled.

YH
