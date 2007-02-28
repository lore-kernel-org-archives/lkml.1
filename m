Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXB1Qej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXB1Qej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXB1Qej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:34:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:54823 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXB1Qei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:34:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VaMxcJs34KoitLdJP7KWSHxTJrnISEhuSYa/IfXNkGcI/7Z1fqMKoweXvx8gWsYZ4TpNtEKqScx4LbzOgrpjyKaT2iEZ2KugoCmUEet1itg2Ed0DKpsFOsz4Q/zHrexHSbBi0y17ddIZ20xv3vAIlokJsNSvQxu+7nTgDufUiQc=
Message-ID: <d120d5000702280834v64748e9fj485642735866b994@mail.gmail.com>
Date: Wed, 28 Feb 2007 11:34:31 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Fausto Carvalho" <faustocarva@gmail.com>
Subject: Re: Fwd: Using serio_register_driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <abe01d5c0702270241s75f70301y6e1cddacf65e8829@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <abe01d5c0702261503p3212d7dcg925588bb325a4460@mail.gmail.com>
	 <abe01d5c0702261732k6634ff02u69e07562a39b9a8d@mail.gmail.com>
	 <200702270034.09603.dtor@insightbb.com>
	 <abe01d5c0702270241s75f70301y6e1cddacf65e8829@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Fausto Carvalho <faustocarva@gmail.com> wrote:
> Well, i have a 8042 controller "connected" to the keyboard controller
> that send information about battery and others to the keyboard
> interrupt and io ports in the format of keystrokes. I want a way to
> not alter atkbd but to create another driver that lives together with
> atkbd. Is there a way?
>

Depending on how big and box-specific the code is we could either add
it to i8042
or you need to imaplement a pass-through serio port in your driver.
You would filter out "interesting" bytes and pass the rest to the new
serio port that your driver shoudl register. Tnen atkbd would bind to
that new port and function as usual. The only problem is that you
woudl need to bind you driver to the keyboard port from userspace (via
sysfs - /sys/bus/devices/serioX/drvctl)

-- 
Dmitry
