Return-Path: <linux-kernel-owner+w=401wt.eu-S937031AbYCTADt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937031AbYCTADt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965720AbYCSWzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:55:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:43018 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965662AbYCSWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aHGdk61IGlLZyrHps8Zuz7ymmiwnbVO/90ak0fSXpSixRNrd8TF/tzmsL+P06UOmddxEZwwANurGsmrZbq6JwYNku6BX6IFMUgb+fdpTmfZsxHzQsBPPOuHsdfdYcn/yDsIJoCs4tmdouck3w9uvC+JSufB7ivyt/3PGth3dk9o=
Message-ID: <45a44e480803191555vfcfe493r4f2fd267097d9a38@mail.gmail.com>
Date: Thu, 20 Mar 2008 06:55:11 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Cc: armbru@redhat.com, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <20080319153946.a5a8060e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	 <87k5kt6vd3.fsf@pike.pond.sub.org>
	 <45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	 <871w6z6ajs.fsf@pike.pond.sub.org>
	 <45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
	 <87iqzjat6e.fsf@pike.pond.sub.org>
	 <45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
	 <20080319113745.d3873de0.akpm@linux-foundation.org>
	 <45a44e480803191530p27ec9575l260d6de063a8d6bf@mail.gmail.com>
	 <20080319153946.a5a8060e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 6:39 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  Well all we have in the changelog is
>
>   Implement support for the E-Ink Metronome controller.  It provides an
>   mmapable interface to the controller using defio support.  It was tested
>   with a gumstix pxa255 with Vizplex media using Xfbdev and various X
>   clients such as xeyes, xpdf, xloadimage.
>
>  grump.  This say nothing at all about the change to drivers/video/fb_defio.c.

I apologize. I should have done better.

>
>  a) the changelog _should_ document this change.  Please send a paragraph and
>    I'll add it.

This patch fixes the following bug. Defio would cause a hang on write
access to the framebuffer as the page fault would be called
ad-infinitum. It fixes fb_defio by setting the mapping to be used by
page_mkclean.

>
>  b) If this discussion hadn't happened, that bug (whatever it is) would
>    have remained unfixed in 2.6.25.  As a direct consequence of poor
>    changelogging.

Understood. The root cause of my flaw was my assumption that other
than me, there weren't any users of defio so I was in no hurry to get
it fixed.

>
>  c) This bugfix (whatever it is) should have been in a separate patch.

Understood. It won't happen again.

Thanks,
jaya
