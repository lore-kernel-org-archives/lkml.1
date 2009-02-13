Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZBMNln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZBMNln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZBMNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:41:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:54528 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZBMNle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hYsHTuotOTBDNtMpn/VEmoV22itLqQvWUb6mxd4wq9PXnwJFVe8Ok4OFxIrM8cEGuM
         XS3/tzO+Lrv3ArG/qrMeXGLgo3hP8nGEmn2BfFfEFn2MDJRdJDXMbOyBiLhLeX87aFtI
         8AunFsoKTO7O2qkFs0dVLiRQf4Yh9xQWBuzjY=
MIME-Version: 1.0
In-Reply-To: <49957F98.50708@st.com>
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>
	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
	 <49954F9A.5020801@st.com>
	 <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com>
	 <4995565D.5010105@st.com> <49957F98.50708@st.com>
Date: Fri, 13 Feb 2009 15:41:29 +0200
X-Google-Sender-Auth: 1df4703310730403
Message-ID: <84144f020902130541n6de09d7brb455d0879b62af71@mail.gmail.com>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
	64-bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giuseppe,

On Fri, Feb 13, 2009 at 4:11 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> @@ -2262,7 +2266,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>                ralign = align;
>        }
>        /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> +       if (ralign > ARCH_SLAB_MAX_DEBUG_ALIGN)
>                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>        /*
>         * 4) Store it.

This doesn't address the issues raised by Paul at all.

                                Pekka
