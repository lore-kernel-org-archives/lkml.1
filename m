Return-Path: <linux-kernel-owner+w=401wt.eu-S1422822AbXBUTTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822AbXBUTTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422823AbXBUTTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:19:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:16308 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422822AbXBUTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=meAPDgdUmxt8vpKxSnCN3fT1yM+TPf+kf3Uh8xbwmBy5xPN+1r19WUh0Y1zekbw0bt1bZRbSuZtHXI4u9YRIjUjYx+e7cKiZ1HKbGn+ITJCXiUvIzLx8l9AgfwlJrgNKS+2eqxoEX4DaJXbj/Rtff/F9ndyATLlWCq72RCfdfY0=
Message-ID: <84144f020702211119ub028ccahee15629f02491840@mail.gmail.com>
Date: Wed, 21 Feb 2007 21:19:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/3] slab: introduce krealloc
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
In-Reply-To: <Pine.LNX.4.64.0702211041061.24941@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
	 <45DC8DA1.6030100@cs.helsinki.fi>
	 <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
	 <45DC916E.1020300@cs.helsinki.fi>
	 <Pine.LNX.4.64.0702211041061.24941@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: ea656dc536d67fd2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Christoph Lameter <clameter@sgi.com> wrote:
> Why not? Its a realloc call and these are the classic semantics of
> realloc. Otherwise realloc will always move the memory.

Well, as a reference, the user-space equivalent is defined in SUSv3 as:

"The realloc() function shall change the size of the memory object
pointed to by ptr to the size specified by size."

I think it is reasonable to expect krealloc() to not waste too much
space if I, say, reallocate a 128 byte buffer to 32 bytes.

On 2/21/07, Christoph Lameter <clameter@sgi.com> wrote:
> Check that both sizes fall into the same general cache. Do the following
> at the beginning of the function

Not available in the slob allocator AFAIK but yeah, I'll add this
optimization to the slab version. Thanks Christoph.

                             Pekka
