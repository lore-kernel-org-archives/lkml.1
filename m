Return-Path: <linux-kernel-owner+w=401wt.eu-S1767419AbXCIRC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767419AbXCIRC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767403AbXCIRC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:02:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:36311 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767419AbXCIRC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZainOJGQtbpn4slCO90/iCnfKp+SC02zN96Yv4pD5h2jafT7NlMFx5zHQ8s9KHadEen2M9ONGSDujBTn8adsbxf3OYyB95cUBXJFS0rBzex2yGBEF4IC2qWvQOKtrhbV3K68LdlAVmCUvfOe6l3VBQo8e4XQzsN/L/OVPmyEuhs=
Message-ID: <84144f020703090902w592da639p9507c24365a6bf83@mail.gmail.com>
Date: Fri, 9 Mar 2007 19:02:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <20070309161113.GM6209@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
	 <200703091108.58371.dada1@cosmosbay.com>
	 <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
	 <200703091213.35691.dada1@cosmosbay.com>
	 <20070309161113.GM6209@kvack.org>
X-Google-Sender-Auth: 8e2a3ea6175159b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:13:35PM +0100, Eric Dumazet wrote:
> > Then just drop the fget_light() 'optimisation' and always take a reference
> > (atomic on f_count) regardless of single-thread or not. Instead of dirtying
> > f_light, just do the straightforward thing and be with it.
> >
> > (that is : fget_light() = fget() = no more keeping fput_needed everywhere, and
> > convoluted things in some dark sides of the kernel.

On 3/9/07, Benjamin LaHaise <bcrl@kvack.org> wrote:
> And it makes things rather slower for a lot of single threaded applications
> on modern systems.  Yes, fget_light can be done much more cleanly, but please
> don't go around ripping out optimizations just because.

Don't worry, the fget_light() bits are no longer needed:
http://lkml.org/lkml/2007/3/9/151
