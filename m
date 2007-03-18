Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbXCRVm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbXCRVm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCRVm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:42:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:64182 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266AbXCRVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oWqJakHFqhMxE3Mj7wBRxXTBZMpJg6uEoXNFD4SsgIlehCPQpSIiLkG84AV6Goemrv6Ti3/pklrYUyxsLzJUeDDSE3yjSrnaDhuSSJBTtZNQmffTSPADWGgEEpo/iuR8dA5mfhaX+w6o0Z+gQbgYae2PkfmYxX3dg1XTtm/RtAo=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: whence CONFIG_PROVE_SPIN_LOCKING?
Date: Sun, 18 Mar 2007 22:42:21 +0100
User-Agent: KMail/1.8.2
Cc: Jiri Kosina <jikos@jikos.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.64.0703181619540.19832@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.64.0703182156550.12394@twin.jikos.cz> <Pine.LNX.4.64.0703181655430.28474@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703181655430.28474@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703182242.21221.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 18 March 2007 22:06, Robert P. J. Day wrote:
> p.s.  just FYI, i ran my "find dead CONFIG variables" script on the
> entire tree and, as we speak, there are 316 preprocessor tests that
> are testing variables of the form "CONFIG_whatever" for which that
> option is not set anywhere in the tree.  (that is, 316 distinct
> variables, not just 316 distinct tests.)  see the attached script and
> feel free to run it from the top of the tree on your favourite
> directory or sub-directory.

In busybox project we adopted the usage of -Wundef
and we try to minimize usage of #ifdef CONFIG_xxx - each boolean
CONFIG_xxx option for busybox is accompanied with
ENABLE_xxx #define which is 1 or 0, never "undefined",
and we check it instead of CONFIG_xxx.

Because if -Wundef, gcc complains whenever we use #if
on undefined ENABLE_xxx.
--
vda
