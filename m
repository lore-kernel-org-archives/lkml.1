Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXKGDjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXKGDjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXKGDj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:39:26 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:22921 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbXKGDjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=BKln/RcVkSp6frgGslHDvolCJdfoLadKeKXUQPkAa4Xu6/eHFLzCswHJ0TSaBYgAO32Lh8qyMF09kBTTyOgHI//gqOXnZ9za96B4S+m39IlRbKjChKSZC6Rt+FetEuyZEVWsl9uKsyD+YAN3m3sFmHoHgYYL4d//k1SdkDIV1Gw=
Message-ID: <4731334A.6090405@gmail.com>
Date: Tue, 06 Nov 2007 22:38:50 -0500
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com>
In-Reply-To: <4730B753.2000901@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:

> 
> Right now, we would have to have every PCI vendor/device ID pair in the
> virtio PCI driver ID table for every virtio device.

I realize you guys are probably far down this road in the design
process, but FWIW: This is a major motivation for the reason that the
IOQ stuff I posted a while back used strings for device identification
instead of a fixed length, centrally managed namespace like PCI
vendor/dev-id.  Then you can just name your device something reasonably
unique (e.g. "qumranet::veth", or "ibm-pvirt-clock").

(I realize that if you are going to do PCI, you need to make it
PCI-like.  But I think using PCI in the first place is probably the
wrong direction.  IMHO, there's really not a lot of reason to be
constrained by a hardware specification once you decide to go PV.  This
is even more true if you want to support as many platforms as possible
(i.e. platforms that don't have PCI natively).

Regards,
-Greg

