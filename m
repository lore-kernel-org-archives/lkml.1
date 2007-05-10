Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXEJTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXEJTVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXEJTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:21:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:45324 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbXEJTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Mk9cFQd5qIpB+t2d+VQ7RK02xyQNw7JOiEEWnuyfl4cu+YlCC/T9BPOXY2qJ9IcUG7G9E457bOWyM31nGS/1ReC7b57UlxVcDlQWhx4Cxd6lR4FD2M+Bcu2TEdA917oXdnk6Dg0jt3ClOaZHJMeuhG5pYlVfszoxoqf5GJSF1To=
Message-ID: <84144f020705101221y6070ed93he837c59053084fae@mail.gmail.com>
Date: Thu, 10 May 2007 22:21:08 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
Cc: linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 0472f4018d1a0724
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Christoph Lameter <clameter@sgi.com> wrote:
> Or are there valid reason to keep them around? It seems they were mainly
> used for list management which required them to take a spinlock. Taking a
> spinlock in a destructor is a bit risky since the slab allocators may run
> the destructors anytime they decide a slab is no longer needed.
>
> Or do we want to continue support destructors? If so why?

Well, constructors are on their way out too because they don't seem to
give the performance benefit they were designed for anymore. As for
destructors, they have been pretty useless in Linux for a long time
now and we really don't do much "complex initialization" that requires
undo (releasing resources).

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

                             Pekka
