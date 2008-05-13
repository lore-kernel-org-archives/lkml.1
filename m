Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbYEMVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbYEMVBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbYEMVBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:01:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbYEMVBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:01:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vTQtcBrqqe4GY+QHRuNa6v0QiSDFGIhPH5Jke48pcwYnKH4Yg9mzwZ/x5FF4DNUx/
	Y9C+2Wh4oen/EyJOF2W1A==
Message-ID: <6599ad830805131401v29217cf7h71f712efde94d383@mail.gmail.com>
Date: Tue, 13 May 2008 14:01:01 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/8]: CGroup Files: Add a cgroup write_string control file method
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080513130710.36bc65f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.301139000@menage.corp.google.com>
	 <20080513130710.36bc65f7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 1:07 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  >
>  > +     /* If non-zero, defines the maximum length of string that can
>  > +      * be passed to write_string; defaults to 64 */
>  > +     int max_write_len;
>
>  would size_t be a more appropriate type?
>

Probably overkill, but I guess it's technically more correct. Updated
for the next version of these patches.

>
>  s/) (/)(/ would be more conventional.
>

OK, I've updated this and the other extraneous spaces in a separate patch.

>
>  > +     /*
>  > +      * write_string() is passed a nul-terminated kernelspace
>  > +      * buffer of maximum length determined by max_write_len
>  > +      */
>  > +     int (*write_string) (struct cgroup *cgrp, struct cftype *cft,
>  > +                          char *buffer);
>
>  Should these return size_t?

No, it returns 0 or a -ve error code. I've added a comment to this effect.
>  >       char *buffer = static_buffer;
>  > -     ssize_t max_bytes = sizeof(static_buffer) - 1;
>  > +     ssize_t max_bytes =  cft->max_write_len ?: sizeof(static_buffer) - 1;
>
>  A blank line between end-of-locals and start-of-code is conventional
>  and, IMO, easier on the eye.
>
>  Does gcc actually generate better code with that x?:y thing?

I doubt it - but I felt that it made the code a bit clearer since it
reduces repetition. I can change it to

	size_t max_bytes =  cft->max_write_len;

	if (!max_bytes)
		max_bytes = sizeof(static_buffer) - 1;

Paul
