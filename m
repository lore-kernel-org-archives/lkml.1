Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0CCJHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:07:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34004 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0CCJHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=goA69aHFtr5+ztOyQfJBylELIRtUGLhvm4FCRd1f4MW31EpwLPclvREJPf7dcCQEny
         S1aT+/8TSWmwvnzdp4aQ7GYRDcYE/RAFGRxyhkcQxrHO+aLppiItCn1zcTH8vSpFBnv1
         3DWNMplN5g9YR7lG8sACtVO9MgzX5NaK8Xb4g=
MIME-Version: 1.0
In-Reply-To: <1f1b08da1003011259yed7c61bvb18071eb8e465bca@mail.gmail.com>
References: <4B8B901E.4050302@ladisch.de>
	 <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
	 <1f1b08da1003011259yed7c61bvb18071eb8e465bca@mail.gmail.com>
Date: Wed, 3 Mar 2010 01:07:19 -0800
Message-ID: <be233a491003030107u3d9fae9cvc6b4a25db7060ec9@mail.gmail.com>
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 12:59 PM, john stultz <johnstul@us.ibm.com> wrote:
> Yes, CLOCK_MONOTONIC_RAW was added specifically to create a hardware
> agnostic interface that provided a 1:1 ratio to the hardware cycle
> counter used by the timekeeping core. No NTP corrections or slewing
> are applied and it isn't affected by settimeofday calls.
>
> Let me know if you run into any trouble with it.
> thanks

Actually I did run into trouble. CLOCK_MONOTONIC_RAW is defined in
linux/time.h and including that creates a lot of redefinition
conflicts with time.h. I see the linux/ includes aren't intended for
user space code.

Is this clockid meant to be of use to user space code and if so how
would one include the definition successfully? time.h is virtually
impossible to not have included if you're using most anything.
