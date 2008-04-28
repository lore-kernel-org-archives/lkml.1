Return-Path: <linux-kernel-owner+w=401wt.eu-S965759AbYD1USw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759AbYD1USw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbYD1USo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:18:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26755 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbYD1USn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RkIJhuVoEq/hQTLOvoSYsJYG3p0rHOe+FJRcRkNnsYKpe26PM07Zp6MVQKG9q2rxNKPNyKQMhhoIzEd6vu5yzJl0uBY0cryav9dGL037c11mhh31z2s+D+Di1bp+4HvBDGAPrvF/q7Nb1YukxgBZBppTIZPFnGyqbNPe6UwVuhE=
Message-ID: <86802c440804281318o3a6019ddr3d452be53fc60e62@mail.gmail.com>
Date: Mon, 28 Apr 2008 13:18:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
In-Reply-To: <20080428201506.GE15840@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804280206.52641.yhlu.kernel@gmail.com>
	 <200804281244.56938.yhlu.kernel@gmail.com>
	 <20080428201506.GE15840@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 1:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > some BIOS like to use continus MTRR layout, and some X driver can not
>  > add WB entries for graphical cards when 4g or more RAM installed.
>  >
>  > the patch will change MTRR to discrete.
>  >
>  > mtrr_chunk_size= could be used to have smaller continuous block to
>  > hold holes. default is 256m, could be set according to size of
>  > graphics card memory.
>  >
>  > v2: fix -1 for UC checking
>
>  > v3: default to disable, and need use enable_mtrr_cleanup to enable
>  >     this feature
>  >     skip the var state change warning.
>  >     remove next_basek in range_to_mtrr()
>
>  a boot option is often inconvenient though - could you perhaps also make
>  this a Kconfig option, with it defaulting to off? Something like
>  CONFIG_MTRR_SANITIZE=y or so? That way distros can make a conscious
>  decision as well whether they want this feature (for the Xorg they pick)
>  or not.

use disable_mtrr_cleanup and CONFIG_MTRR_SANITIZER?

YH
