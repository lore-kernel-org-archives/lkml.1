Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKFJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKFJtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYKFJsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:48:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYKFJsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:48:51 -0500
Message-ID: <4912BD67.8000704@redhat.com>
Date: Thu, 06 Nov 2008 11:48:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-9-git-send-email-ehabkost@redhat.com> <m1bpwu3wod.fsf@frodo.ebiederm.org> <20081105175235.GJ5247@blackpad>
In-Reply-To: <20081105175235.GJ5247@blackpad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> We could move the set_virt_disable_func() calls to vmx.c and svm.c (on
> hardware_setup/hardware_unsetup). One could argue that it is sort of a
> coincidence that we need the code for both vmx and svm.
>   

I don't share this fear of function calls, but perhaps that's due to 
lack of experience with kdump.

If you want to be extra simple and safe, remove kvm from the equation.  
Make the disabling code part of kdump/emergency_restart and only rely on 
the convention that cr3.vmxe == vmxon.

That has the advantage of working with other virtualization systems as well.

-- 
error compiling committee.c: too many arguments to function

