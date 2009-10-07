Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZJGVwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZJGVwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZJGVwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:52:31 -0400
Received: from claw.goop.org ([74.207.240.146]:59380 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZJGVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:52:30 -0400
Message-ID: <4ACD0D78.2090006@goop.org>
Date: Wed, 07 Oct 2009 14:51:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACCEC18.90401@goop.org> <4ACCF565.30804@redhat.com> <4ACD05D8.5090903@goop.org> <4ACD0A2B.1080307@redhat.com>
In-Reply-To: <4ACD0A2B.1080307@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/09 14:37, Avi Kivity wrote:
> If the guest does a RMW on the version, but the host does not (copying
> it from somewhere else), then the guest RMW can be lost.
>
> Looking at the code, that's what kvm does:
>
>     vcpu->hv_clock.version += 2;
>
>     shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
>
>     memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
>            sizeof(vcpu->hv_clock));
>
> so a guest-side ++version can be lost.

I see, yes.  The Xen code explicitly reads back the guest version and
increments that (I realize now that's what you meant by guest-private
version).  If you were to have a second version number it would have to
be separated as well to avoid being overwritten by the hypervisor.

    J
