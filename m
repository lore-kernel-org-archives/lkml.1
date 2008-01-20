Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYATNI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYATNI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYATNIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:08:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYATNIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:08:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ibpFatGAj82VggJyTHFK2P0RDTDPZ9Xz+f9ZBLSS29pJrLp4h4EGNOmUi2Jf5v/hiFq1Zn59o7vVp62Deg8TQ/Rp+KemL/yd9ABbeNFVPhA0CDSKe/Kc94/8u4ptEgkkF+WS8irFcvArwli6CJQp8oKilS/9DWo4Y8Qyq9HPZhw=
Message-ID: <519a8b110801200508l1fb3dee9ha197f3fc76ccac69@mail.gmail.com>
Date: Sun, 20 Jan 2008 14:08:15 +0100
From: xming <xmingske@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4790E13D.5040603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
	 <478F8D22.60004@goop.org>
	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
	 <4790561E.9040508@goop.org>
	 <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
	 <4790D187.8050000@goop.org>
	 <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>
	 <4790E13D.5040603@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 6:26 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >> Would it be possible to map the eip and some top parts of the stack back
> >> to kernel symbols?  Seems to be the same place in both traces, which is
> >> interesting.

> Do "nm -n vmlinux" on the kernel to set an address sorted list of
> symbols, and then look to see what's near the eip (c037c0c7) and near
> the top of the stack (c0100add, c0378980, c0101962, ...).  Some of these
> may be in data, or other strange places, but the ones which correspond
> to code are interesting.

ok I have done some of them, but I still don't know what I should be looking
at. Do you mean code related to xen or code related to have_vcpu_info_placement?
Please be patient with me :)

I just paste some of the result (around those addresses) here:

c037b000 B empty_zero_page
c037c000 B hypercall_page
c037d000 B system_state

c0100a00 t xen_cpuid
c0100a80 t xen_set_debugreg
c0100a90 t xen_get_debugreg
c0100aa0 t xen_save_fl
c0100ac0 t xen_irq_disable
c0100ad0 t xen_safe_halt
c0100af0 t xen_halt
c0100b20 t xen_store_tr
c0100b30 t cvt_gate_to_trap
c0100bb0 t xen_io_delay


c0378980 D per_cpu__irq_stat
c03789c0 d per_cpu__runqueues
c0378df4 D __per_cpu_end

c01018b0 t xen_flush_tlb_single
c0101940 t xen_idle
c0101980 T xen_setup_features
c01019c0 T xen_mc_flush
c0101aa0 T xen_mc_callback

c0104710 T kernel_thread
c01047c0 T cpu_idle
c0104840 T cpu_idle_wait
c0104940 T exit_thread

c0103fe4 T xen_irq_enable_direct
c0103ff1 T xen_irq_enable_direct_reloc
c0103ff5 T xen_irq_enable_direct_end
c0103ff8 T xen_irq_disable_direct
c0104000 T xen_irq_disable_direct_end
c0104004 T xen_save_fl_direct
c0104011 T xen_save_fl_direct_end
c0104014 T xen_restore_fl_direct
c010402b T xen_restore_fl_direct_reloc

c03483f0 t maxcpus
c0348430 t unknown_bootoption
c0348610 T parse_early_param


> >> Hm, I guess some of the output is getting dropped.  Does this happen
> >> with 2.6.18-xen?

> > yes it does

> OK, good.  I Didn't Break It (tm) ;)

So no fix from you? :)

Thanks
