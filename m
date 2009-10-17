Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZJQQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZJQQDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZJQQDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 12:03:41 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59273 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZJQQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 12:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SxBt09K66L83YPqwObvA4sXo0eLBNUtSvM0zM/vjsezNIsYCKlgNdV3YBgKRpFz5sr
         6quVKPy6PxcuTsI7ya2obZx6u3RdvO2kEdHbu8ELl5335Yzxr9WJQkCNIJZlB0A8yRfl
         FirmVmTT69iL6KjCpmZLRIYAln+2Pm/tIO+zc=
Date: Sat, 17 Oct 2009 18:03:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/2] perf tools: Use DECLARE_BITMAP instead of an
	open-coded array
Message-ID: <20091017160338.GA10344@nowhere>
References: <20091016074222.GD30019@elte.hu> <1255795038-13751-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255795038-13751-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 05:57:18PM +0200, Frederic Weisbecker wrote:
> Use DECLARE_BITMAP instead of an open coded array for our bitmap
> of featured sections.
> 
> This makes the array an unsigned long instead of a u64 but since
> we use a 256 bits bitmap, the array size shouldn't vary between
> different boxes.


That said I would really feel more comfortable if someone can
confirm that.



> @@ -143,12 +141,12 @@ struct perf_file_header {
>  	struct perf_file_section	attrs;
>  	struct perf_file_section	data;
>  	struct perf_file_section	event_types;
> -	feat_mask_t			adds_features;
> +	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);


I think having adds_features as an unsigned long won't
hurt because we have HEAD_FEAT_BITS % 64 == 0

It would certainly hurt if we had, say, HEAD_FEAT_BITS = 257

But may be I forget a corner case. I hope someone can double
check that. Thanks.

