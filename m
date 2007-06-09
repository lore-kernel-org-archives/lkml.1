Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbXFIS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbXFIS4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbXFIS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:56:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:31992 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbXFIS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eOelgHuh8Li7FWXPnwO5ugZ2H63PKKDkvAq83lp9tFaNkTUB+c6PoqX8IP6pFwyNATBYthedl1ph6w1la3EPXK6Q3WFhQ6Rxj1pLww6QD13hsyk36mRfvfdRYv1n0/aDStvgAI4f2xpLMqhSIq5iGP01JEwiS/v4o7O6R2jai4g=
Message-ID: <a781481a0706091156n773b5449n5d4a96134c3f9b66@mail.gmail.com>
Date: Sun, 10 Jun 2007 00:26:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Size of kernel modules
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Kyle McMartin" <kyle@canonical.com>,
       "Christoph Pleger" <Christoph.Pleger@cs.uni-dortmund.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
	 <20070608034421.GM26717@fattire.cabal.ca>
	 <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
	 <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
	 <1181390911.3306.22.camel@jcmlaptop>
	 <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jun 9 2007 08:08, Jon Masters wrote:
> >
> >So I missed half of this conversation - you're saying that on a
> >CONFIG_DEBUG_KERNEL, you have such large .ko module files that depmod
> >segfaults? Can I get a core dump or any further information? :-)
>
> Just make sure your /lib/modules/<kernel> is like 300 megabytes or even
> more. Then depmod will clog up quite a lot memory already. (Taking a 256 mb ram
> machine for example, no swap or just very little.)

Yup, this would happen reproducibly on a machine with <= 256MB
RAM and swap disabled, when building a large enough modular kernel.
The depmod at end of modules_install would invariably invoke the OOM
killer, and get itself shot (taking down the shell with it, often) ...

Satyam
