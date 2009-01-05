Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZAEKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZAEKDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZAEKDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:03:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:31169 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZAEKDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u104wPh5zWfxjzrWWW5M2Nh9jfLspFYt08C0ag+9klhg6g+sOh17SpkvQ1300CpFzz
         ZsJTWSLpFalngFL9j1KmgFue9IJVUaWG5nEID6PqwtkKf/waI++MKgpVKgRcwH2VcuEP
         Qydkv1Yix7Ozz3Fx7eb4mqQp5Rr4jEVhzYPc4=
Date: Mon, 5 Jan 2009 13:03:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
Message-ID: <20090105100318.GC7645@localhost>
References: <20090105094034.GA7645@localhost> <84144f020901050200h3fd6ce71qacd5e2dff282a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020901050200h3fd6ce71qacd5e2dff282a9@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, Jan 05, 2009 at 12:00:58PM +0200]
| Hi Cyrill,
| 
| On Mon, Jan 5, 2009 at 11:40 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > @@ -980,9 +986,12 @@ extern struct mem_section mem_section[NR
| >
| >  static inline struct mem_section *__nr_to_section(unsigned long nr)
| >  {
| > -       if (!mem_section[SECTION_NR_TO_ROOT(nr)])
| > +       unsigned long idx = SECTION_NR_TO_ROOT(nr);
| > +       WARN_ON_ONCE(idx >= NR_SECTION_ROOTS);
| > +
| > +       if (idx >=NR_SECTION_ROOTS || !mem_section[idx])
| >                return NULL;
| 
| Looks good to me but I have minor nitpick. You might want to write the
| above like this:
| 
|     if (WARN_ON_ONCE(idx >= NR_SECTION_ROOTS))
|             return NULL;
| 
| to separate the error condition from the normal case where we don't
| have a mem section.
| 
| > -       return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
| > +       return &mem_section[idx][nr & SECTION_ROOT_MASK];
| >  }
| 

Hi Pekka,

thanks, indeed! I forget that WARN_.. do return a value :)
Will fix shortly.

		- Cyrill -
