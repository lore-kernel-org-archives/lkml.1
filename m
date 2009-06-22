Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZFVEkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZFVEkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 00:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZFVEkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 00:40:11 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:45096 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFVEkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 00:40:11 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       tglx@linutronix.de, hpa@zytor.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] mm: clear N_HIGH_MEMORY map before se set it again -v4
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie>
 <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie>
 <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org>
 <20090514095414.ba8356e5.akpm@linux-foundation.org>
 <4A0C4F67.5080802@kernel.org>
 <20090514102554.b3a36f19.akpm@linux-foundation.org>
 <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org>
 <alpine.DEB.1.10.0906041236520.5377@gentwo.org> <4A27FAD4.2010104@kernel.org>
 <alpine.DEB.1.10.0906041309230.8080@gentwo.org> <4A2803D1.4070001@kernel.org>
 <m3bpokiv0u.fsf@pobox.com> <4A3B49BA.40100@kernel.org>
 <m3prd0havh.fsf@pobox.com> <4A3D7419.8040305@kernel.org>
From: Nathan Lynch <ntl@pobox.com>
Date: Sun, 21 Jun 2009 23:39:56 -0500
In-Reply-To: <4A3D7419.8040305@kernel.org> (Yinghai Lu's message of "Sat\, 20
 Jun 2009 16\:43\:21 -0700")
Message-ID: <m3my807ug3.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C664D804-5EE6-11DE-94C0-B5D1A546830D-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:
> please check
>
> [PATCH] x86: only clear node_states for 64bit
>
> Nathan reported that
> | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
> | Author: Yinghai Lu <yinghai@kernel.org>
> | Date:   Tue Jun 16 15:33:00 2009 -0700
> |
> |    page-allocator: clear N_HIGH_MEMORY map before we set it again
> |    
> |    SRAT tables may contains nodes of very small size.  The arch code may
> |    decide to not activate such a node.  However, currently the early boot
> |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
> |    active although these nodes have no present pages.
> |    
> |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
>
> the cpuset.mems cgroup attribute on an i386 kvm guest
>
> try to fix it by only clear node_states[N_NORMAL_MEMORY] for 64bit only.
> and need to do save/restore for that in find_zone_movable_pfn

This works for my setup, thanks.
