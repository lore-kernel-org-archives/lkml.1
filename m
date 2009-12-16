Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbZLPTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbZLPTva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbZLPTvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:51:24 -0500
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:49777 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759004AbZLPTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:51:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JM4HD+KlNHGXvlRsbQNkYCS7hQQW75elGV3TP00HNOjqygct9nk/oCebk49aRDBli9NfvYI/4phTPXdyiuAxE5LTwjcFMDuCDXK5oYy5Y8+fsKyP9ThlOT8WyAWF4vNp;
Date: Wed, 16 Dec 2009 11:51:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: 2.6.32.1 i915 KMS rmmod failure
Message-ID: <20091216115103.042aacdf@jbarnes-piketon>
In-Reply-To: <m3d42e20v3.fsf@intrepid.localdomain>
References: <m3d42e20v3.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 20:08:16 +0100
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Hi,
> 
> The following sequence causes the machine to hang hard:
> modprobe drm debug=65535
> modprobe i915 modeset=1
> rmmod i915
> 
> Linux 2.6.32.1 x86-64, i915 (the machine is a slimline MSI Hetis 915
> barebone), 2 GB RAM etc. Kernel messages captured with a serial
> console. Only analog VGA output connected (no EDID, using a "pro" 5 *
> BNC cable to connect to an old analog monitor). There is
> (unconnected) digital DVI and a TV encoder. Other details available
> on request.
> 
> The IRQ happens in intel_pipe_set_base()
> 
> 	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset,
> x, y); I915_WRITE(dspstride, crtc->fb->pitch);
> 	if (IS_I965G(dev)) {
>         	...
> 	} else {
> 		I915_WRITE(dspbase, Start + Offset);
> 		I915_READ(dspbase);
>   >>>>>>> IRQ seems to be triggered at this point <<<<<<<
> 	}
> 
> Any ideas?

Seems like we should be disabling everything at unload time rather than
trying to set a new mode... If the dspbase we program isn't mapped
anymore we'd definitely get into trouble.

-- 
Jesse Barnes, Intel Open Source Technology Center
