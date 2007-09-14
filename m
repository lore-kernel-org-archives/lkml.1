Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXINRkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXINRkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXINRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:40:30 -0400
Received: from 8bytes.org ([88.198.83.132]:43293 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXINRka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:40:30 -0400
Date: Fri, 14 Sep 2007 19:40:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070914174028.GC8998@8bytes.org>
References: <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <46EA3F07.9050806@gmail.com> <20070914091535.GA8998@8bytes.org> <46EA77DE.8060109@gmail.com> <20070914161345.GB8998@8bytes.org> <46EABD48.3020902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EABD48.3020902@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 08:56:40PM +0400, Manu Abraham wrote:
> 
> I do understand that (an earlier reply from Grant Grundler on the same
> [1], while working on something else), but that wasn't exactly what i
> was getting at. The bridges are in fact tied up with a certain CPU class.
> 
> Though your argument holds true: "secure userpsace device drivers can be
> implemented with modern hardware" There is a large flaw in it. (From an
> academic POV, you are correct)
> 
> Now, if all the drivers were to depend on that certain feature, what
> happens to all other CPU class users ? Looking at a pile of CPU's being
> used, also not to forget that devices such as STB's use even very small
> embedded CPU's such as the PPC405 Vulcan based [2] to mobile devices
> such as mobile phones using ARM, Xtensa [3], OMAP CPU's/platforms, which
> do not in any way use the bridges nor the CPU class which you however
> mention.

This is true. These platforms do not (and afaik will not) have an
IOMMU and thus its impossible to implement a secure userspace driver
interface that supports DMA. In general, IOMMUs are only expected on
platforms which implement virtualization, have a processor address space
larger than the io address space or both.

> So .. we are looking at a small segment, ie. a subset of the PC users
> even, even if the larger segments like STB's can be ignored. This would
> mean that only a small subset of users using a certain CPU class can use
> those drivers (eventhough the devices themselves don't have that
> limitation, the limitation being the implementation of the driver
> alone), which is absurd.

This is also true. But looking at the current development of
virtualization in hardware on the PC market (and also the increasing
amount of main memory) makes me sure that in a few years every new sold
_PC_ will haven an IOMMU inside. But the problems with the other
platforms or older hardware will certainly remain.

Joerg
