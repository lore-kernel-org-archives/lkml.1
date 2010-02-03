Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0BCH1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 02:27:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:64619 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0BCH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 02:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HLnVyOZ1Sq4VyB2WrVA7zbXvfB3leZ2galQys9bPZt9jwFdrSz2Z3ge2uLir4G4+Cq
         t5FXsGFAbzoJEcUNoAJlsepHfMgbB/SfVWGTQWBlqfog9q1XAKhd+PNH6E8AALitZZlK
         EaFwvrC8PnfE/am8aFgf9q5g+zAHtnwjpfeVw=
Date: Wed, 3 Feb 2010 08:21:23 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: zhiyi <zhuang@cs.otago.ac.nz>
Cc: linux-kernel@vger.kernel.org, jkmair@cs.otago.ac.nz
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Message-ID: <20100203072123.GA5428@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	zhiyi <zhuang@cs.otago.ac.nz>, linux-kernel@vger.kernel.org,
	jkmair@cs.otago.ac.nz
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
 <20100130171804.GA2348@liondog.tnic>
 <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
 <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
 <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com>
 <4086DEE4-5D26-4EED-8353-2C4F54238CAE@cs.otago.ac.nz>
 <20100202070751.GA11623@liondog.tnic>
 <D65A73B5-D44A-4AEF-8B0E-35DC119127C9@cs.otago.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D65A73B5-D44A-4AEF-8B0E-35DC119127C9@cs.otago.ac.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:33:46AM +1300, zhiyi wrote:
> The good thing is that I realized I should use num_present_cpus()
> instead of nr_cpu_ids for my purpose (get the number of real cores
> on the machine)

Just a minor thing: there could be a subtlety with hotplug when
using num_present_cpus() since this includes all CPUs, even the
hotplug-offlined ones. Depending on your case, you might want to use
num_online_cpus() instead. Look at the comment at the beginning of
<include/linux/cpumask.h> which explains all the different masks to
figure out which one fits your needs best.

-- 
Regards/Gruss,
    Boris.
